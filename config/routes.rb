require 'api_constraints'

Rails.application.routes.draw do
  # devise_for :users, ActiveAdmin::Devise.config
  devise_for :users
  ActiveAdmin.routes(self)
  root to: "static_pages#home"
  get 'static_pages/home'
  
  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      get '/test/', to: 'test#show'
      resources :users, except: [:index, :new, :edit]
      namespace :rezzable do
        resources :terminals, except: [:index, :new, :edit]
        resources :servers, except: [:index, :new, :edit]
        resources :vendors, except: [:index, :new, :edit]
        resources :web_objects, except: [:index, :new, :edit]
      end
      namespace :analyzable do 
        resources :transactions, only: [:create]
        resources :inventories, except: [:index, :new, :edit]
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
