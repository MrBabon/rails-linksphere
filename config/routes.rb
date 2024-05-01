Rails.application.routes.draw do
  get 'current_user', to: 'current_user#index'
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
    resource :repertoire, only: [] do
      resources :contact_groups, only: [:create, :new, :edit]
    end
    member do
      get 'profil'
      get 'repertoire'
    end
  end

end
