Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'scrape', to: 'scraping#scrape'
      resources :scraped_data, only: [:index]
    end
  end
end
