Rails.application.routes.draw do

  
  #  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  #authentication start
	get '/login'     => 'sessions#new'
	post '/login'    => 'sessions#create'
	delete '/logout' => 'sessions#destroy'
  #authentication end
  
  post 'login/', to: 'users#login'

  resources :subdivision, param: :uuid do
    resources :residence, param: :residence_uuid  do
      member do
        resources :monthly_bill do
          collection do
            get ':year/:month', to: 'monthly_bill#bill'
          end
        end
      end
    end

    resources :monthly_dues
    resources :monthly_dues_transactions
    resources :water_billing_transactions
    resources :water_billing do
      member do
        post "upload_image"
      end
    end
  end
  resources :subdivision_setting do
    member do
      get "prepare_register_link"
    end
  end

  

  


  # Defines the root path route ("/")
  root "subdivision#index"
end
