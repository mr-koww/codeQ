require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |user| user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  root to: 'questions#index'

  use_doorkeeper

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  resources :users, only: [ :show, :update ] do
    patch :change_email, on: :member
  end

  concern :votable do
    member do
      patch :like
      patch :dislike
      patch :unvote
    end
  end

  resources :questions, concerns: [ :votable ] do
    resources :answers, only: [ :create, :update, :destroy ], concerns: [ :votable ], shallow: true do
      put :best, on: :member
      resources :comments, only: :create, defaults: { commentable: 'answer' }
    end

    resources :comments, only: :create, defaults: { commentable: 'question' }
    resources :subscribers, only: [ :create, :destroy ], shallow: true
  end

  resources :attachments, only: [ :destroy ]
  resources :comments, only: [ :update, :destroy ], shallow: true

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
      resources :questions, only: [ :index, :show, :create ] do
        resources :answers, only: [ :index, :show, :create ], shallow: true
      end

    end
  end
end
