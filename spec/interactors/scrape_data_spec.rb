require 'rails_helper'
require 'webmock/rspec'

RSpec.describe WebScrapingInteractor, type: :interactor do
  let(:url) { 'https://www.webmotors.com.br/comprar/chevrolet/cruze/14-turbo-lt-16v-flex-4p-automatico/4-portas/2022-2023/51047580?pos=a51047580p:&np=1' }
  let(:page_body) { File.read(Rails.root.join('spec/fixtures/webmotors_page.html')) }

  before do
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  it 'successfully scrapes and saves data' do
    stub_request(:get, url).to_return(status: 200, body: page_body, headers: {})
    stub_request(:post, 'http://localhost:3000/api/v1/notifications')
      .with(
        body: { message: 'Web scraping completed', url: url }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
      .to_return(status: 200, body: '', headers: {})

    result = WebScrapingInteractor.call(url: url)

    expect(result).to be_success
    expect(ScrapedData.last.brand).to eq('Chevrolet')
    expect(ScrapedData.last.model).to eq('Cruze LT')
    expect(ScrapedData.last.price).to eq('R$ 85.000')
    expect(WebMock).to have_requested(:post, 'http://localhost:3000/api/v1/notifications')
  end

  it 'fails to scrape due to an error' do
    allow_any_instance_of(WebScrapingInteractor).to receive(:fetch_page).and_raise(StandardError, 'Some error')

    result = WebScrapingInteractor.call(url: url)

    expect(result).to be_failure
    expect(result.error).to eq('Some error')
  end
end
