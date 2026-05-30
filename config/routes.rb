Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  Rails.application.routes.draw do
    namespace :api do
      namespace :v1 do
        resources :users, only: [ :create, :show ]

        resources :posts, only: [ :index, :create, :update, :destroy ] do
          resources :reactions, only: [ :create ]
        end

        resources :stickers, only: [ :create, :index ] do
          collection do
            get :signature
          end
        end
      end
    end
  end
end
