Rails.application.routes.draw do
  get "pages/about"
  get "tags/index"
  get "tags/show"
  get "ingredients/index"
  get "ingredients/show"
  get "areas/index"
  get "areas/show"
  get "categories/index"
  get "categories/show"
  get "meals/index"
  get "meals/show"
  root "meals#index"
resources :meals, only: [:index, :show]
resources :categories, :areas, :ingredients, :tags, only: [:index, :show]
get "about", to: "pages#about"
end
