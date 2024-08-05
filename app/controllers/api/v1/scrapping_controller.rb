class Api::V1::ScrapingController < ApplicationController
  def scrape
    result = ScrapeData.call(url: params[:url])

    if result.success?
      render json: { data: result.data }, status: :ok
    else
      render json: { error: result.message }, status: :unprocessable_entity
    end
  end
end
