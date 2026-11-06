Rails.application.routes.draw do
  # Home page = list of all meals
  root "pages#home"

  # List page (index) and detail page (show) for each model
  resources :meals, only: [:index, :show] do
    collection { get :random }
  end
  resources :categories, :areas, :ingredients, :tags, only: [:index, :show]

  # Static About page
  get "about", to: "pages#about"
end
