require 'nokogiri'
require 'open-uri'

class WebScrapingInteractor

  include Interactor

  def call
    context.page = fetch_page
    context.data = extract_data
    save_data
    notify_completion
  rescue StandardError => e
    context.fail!(error: e.message)
  end

  private

  def fetch_page
    Nokogiri::HTML(URI.open(context.url))
  end

  def extract_data
    page = context.page
    {
      brand: page.at_css('span[data-testid="brand"]').text.strip,
      model: page.at_css('span[data-testid="model"]').text.strip,
      price: page.at_css('span[data-testid="price"]').text.strip
    }
  end

  def save_data
    ScrapedData.create!(context.data)
  end

  def notify_completion
    HTTParty.post('http://localhost:3000/api/v1/notifications',
                  body: { message: 'Web scraping completed', url: context.url }.to_json,
                  headers: { 'Content-Type' => 'application/json' })
  end
end
