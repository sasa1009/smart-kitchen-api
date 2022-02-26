Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  namespace :api do
    namespace :v1 do
      resources :test, only: %i[index]
      get 'presigned-url', to: 's3#presigned_url'

      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/auth/registrations'
      }

      namespace :auth do
        resources :sessions, only: %i[index]
      end

      resources :users, only: %i[index show update]
      get '/users/:id/followings', to: 'users#followings'
      get '/users/:id/followers', to: 'users#followers'

      resources :recipes, only: %i[index create show update destroy]
      get '/recipes/:user_id/user', to: 'recipes#user'
      get '/recipes/:user_id/favorite', to: 'recipes#favorite'
      get '/recipes/:user_id/following', to: 'recipes#following'
      get '/recipe_ranking', to: 'recipes#ranking'

      resources :food_logs, only: %i[index create destroy]
      resources :food_log_templates, only: %i[index destroy]

      post '/favorites', to: 'favorites#create'
      delete '/favorites', to: 'favorites#destroy'

      post '/relationships', to: 'relationships#create'
      delete '/relationships', to: 'relationships#destroy'

      resources :notifications, only: %i[index]
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
