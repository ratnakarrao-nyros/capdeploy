Topfive::Application.routes.draw do

  root :to => 'pages#show', :id => 'home'
  match '/pages/*id' => 'pages#show', :as => :page, :format => false
  resources :contacts, :only => [:new, :create]
  resources :items, :only => [:show]

  # => API routes
  namespace :api do
    get "filter_by_category" => "common#filter_by_category", :as => :filter_by_category
    post "upload_image" => "common#upload_image", :as => :upload_image
    get "current_user_object" => "common#current_user_object", :as => :current_user_object
  end

  devise_for :admins, :controllers => { :sessions => "admins/sessions" }
  devise_for :users, :controllers => { :sessions => "users/sessions", :registrations => "users/registrations", :omniauth_callbacks => "users/omniauth_callbacks", :passwords => "users/passwords", :confirmations => "users/confirmations" }
  devise_scope :user do
    get 'users/sign_up_by_provider' => 'users/registrations#new_by_provider', :as => :new_user_registration_by_provider
    post 'users/sign_up_by_provider' => 'users/registrations#create_by_provider', :as => :user_registration_by_provider
  end

  # => Admin routes
  namespace :admins do
    root :to => 'dashboard#index'
    resources :admins
    resources :users
    resources :items
    resources :lists do
      member do
        put :approve
        put :reject
      end
    end
    resources :contacts, :only => [:index, :show, :destroy]
    resources :forum_categories
    resource :settings, :only => [:show, :edit, :update]
  end

  # => User routes
  namespace :users do
    root :to => 'home#index'
    resource :user, :only => [:edit, :update, :destroy]
    resource :profile, :only => [:show, :edit, :update]
    resources :lists, :except => [:destroy] do
      resources :listings, :only => [] do
        member do
          post :vote
        end
        resources :comments, :only => [:index, :create] do
          member { post :vote }
        end
      end
    end
    resource :items, :only => [:create, :update]
  end

  # => Forum routes
  resources :forums, :except => :index do
    resources :topics, :controller => "forums/topics", :except => :index do
      resources :posts, :controller => "forums/posts", :except => [:index, :show]
    end
    root :to => 'forums/forum_categories#index', :via => :get
  end

end
