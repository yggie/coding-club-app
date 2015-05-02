Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    get 'sign_in', to: 'users/sessions#new', as: :new_user_session
    get 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'static_pages#home_page'

  get '/settings', to: 'users#edit', as: :edit_user
  patch '/settings', to: 'users#update', as: :update_user

  get '/dashboard', to: 'users#dashboard', as: :users_dashboard
  get '/newsletters/archived', to: 'newsletters#archived', as: :archived_newsletters
  get '/events/archived', to: 'events#archived', as: :archived_events

  resources :events, only: [:new, :create, :edit, :update]

  resources :newsletters, only: [:new, :create, :show, :update] do
    get :confirm
    get :send_to_test_group
    get :send_to_subscribed_group
  end

  resource :newsletter, only: [] do
    post :preview
    patch :preview
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end
end
