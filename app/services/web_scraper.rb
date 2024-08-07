class WebScraper
  def initialize(url)
    @url = url
  end

  def scrape
    result = WebScrapingInteractor.call(url: @url)

    if result.success?
      { success: true }
    else
      { success: false, error: result.error }
    end
  end
end
