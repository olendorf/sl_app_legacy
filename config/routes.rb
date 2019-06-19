require 'api_constraints'

Rails.application.routes.draw do
  devise_for :users
  root to: "static_pages#home"
  get 'static_pages/home'
  
  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, except: [:index, :new, :edit]
      # namespace :rezzable do
      #   resources :web_objects, except: [:index, :new, :edit]
      # end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
