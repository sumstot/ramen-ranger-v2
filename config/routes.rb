Rails.application.routes.draw do
  resources :comments
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root 'ramen_reviews#index'

  get '/map', to: 'restaurants#map'
  get '/hall_of_fame', to: 'restaurants#hall_of_fame'

  resources :restaurants do
    resource :favorite, module: :restaurants
  end
  resources :ramen_reviews do
    resource :favorite, only: [:update], module: :ramen_reviews
    resource :like
  end
end
