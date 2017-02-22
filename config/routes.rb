Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true do
      patch :mark_best, on: :member
    end
  end

  root 'questions#index'
end
