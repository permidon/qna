Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    resources :votes, only: [:create, :destroy]
  end

  resources :questions, concerns: :votable do
    resources :comments, only: [:create]
    resources :answers, concerns: :votable, shallow: true do
      resources :comments, only: [:create]
      patch :mark_best, on: :member
    end
  end
  resources :attachments, only: [:destroy]

  root 'questions#index'

  mount ActionCable.server => '/cable'
end
