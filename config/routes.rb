# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    resources :players, only: [:index]
  end
  resources :quizzes, only: %i[new create show update] do
    member do
      get 'results'
    end
  end
  root 'quizzes#new'
end
