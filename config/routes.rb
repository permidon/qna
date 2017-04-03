require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end


  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    post 'confirm_email', to: 'omniauth_callbacks#confirm_email'
  end

  concern :votable do
    resources :votes, only: [:create, :destroy]
  end

  resources :questions, concerns: :votable do
    resources :subscriptions, only: [:create, :destroy], shallow: true
    resources :comments, only: [:create]
    resources :answers, concerns: :votable, shallow: true do
      resources :comments, only: [:create]
      patch :mark_best, on: :member
    end
  end
  resources :attachments, only: [:destroy]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, only: [:index, :show, :create] do
        resources :answers, only: [:index, :show, :create], shallow: true
      end
    end
  end

  root 'questions#index'

  mount ActionCable.server => '/cable'
end
