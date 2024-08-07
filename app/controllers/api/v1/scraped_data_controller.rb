class Api::V1::ScrapedDataController < ApplicationController
  def index
    @scraped_data = ScrapedData.where(model: params[:model])
    render json: @scraped_data
  end

  def scrape
    url = params[:url]
    result = WebScraper.new(url).scrape

    if result[:success]
      render json: { message: 'Scraping started' }, status: :ok
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  end
end
