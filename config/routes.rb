Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    get 'sign_in', to: 'users/sessions#new', as: :new_user_session
    get 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'newsletters#index'

  get '/settings', to: 'users#edit', as: :edit_user
  patch '/settings', to: 'users#update', as: :update_user

  resources :newsletters, only: [:show, :index, :update] do
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
