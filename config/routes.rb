Rails.application.routes.draw do

  root 'pages#home'
  get 'redirect', to: 'pages#redirect'
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  resources :users do
    resources :user_contact_groups, only: :create
    resource :repertoire, only: [] do
      resources :contact_groups, only: [:create, :new, :edit, :show, :destroy, :update] do
        resources :user_contact_groups, only: [:show, :update] do
          collection do
            post 'add_to_group'
          end
        end
      end
    end
    member do
      get 'profil'
      get 'repertoire'
      get 'entreprise_contact'
      get 'my_events'
      patch 'update_preferences'
    end
  end

  resources :chatrooms, only: [:show, :index, :create, :destroy] do
    resources :messages, only: :create
  end

  resources :blocks, only: [:create, :destroy]

  resources :events, only: [:index, :show] do
    member do
      get 'visitor'
      get 'exposant'
    end
    resources :participations, only: [:create, :destroy, :update]
    resources :exhibitors, only: [:show]
  end

  resources :entreprises, only: [:edit, :update, :show, :new, :create] do
    resources :contact_entreprises, only: [:create]
    member do
      post 'add_to_repertoire'
    end
  end


end
