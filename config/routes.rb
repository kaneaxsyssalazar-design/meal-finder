Rails.application.routes.draw do
  # Home page = list of all meals
  root "meals#index"

  # List page (index) and detail page (show) for each model
  resources :meals, only: [:index, :show]
  resources :categories, :areas, :ingredients, :tags, only: [:index, :show]

  # Static About page
  get "about", to: "pages#about"
end
