class ScrapeData
  include Interactor

  def call
    url = context.url
    response = HTTParty.get(url)

    if response.success?
      doc = Nokogiri::HTML(response.body)
      titles = doc.css('h1, h2, h3').map(&:text)
      context.data = titles
    else
      context.fail!(message: 'Failed to fetch data from the URL')
    end
  rescue StandardError => e
    context.fail!(message: e.message)
  end
end
