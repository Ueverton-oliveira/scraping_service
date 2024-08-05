require 'rails_helper'

RSpec.describe ScrapeData, type: :interactor do
  let(:url) { 'http://example.com' }

  context 'when the request is successful' do
    before do
      stub_request(:get, url).to_return(body: "<html><h1>Title</h1></html>")
    end

    it 'returns the scraped data' do
      result = ScrapeData.call(url: url)
      expect(result).to be_success
      expect(result.data).to eq(['Title'])
    end
  end

  context 'when the request fails' do
    before do
      stub_request(:get, url).to_return(status: 500)
    end

    it 'returns an error message' do
      result = ScrapeData.call(url: url)
      expect(result).to be_failure
      expect(result.message).to be_present
    end
  end

  context 'when an exception occurs' do
    before do
      allow(HTTParty).to receive(:get).and_raise(StandardError.new('Some error'))
    end

    it 'returns an error message' do
      result = ScrapeData.call(url: url)
      expect(result).to be_failure
      expect(result.message).to eq('Some error')
    end
  end
end
