# frozen_string_literal: true

Rails.application.routes.draw do
  resources :quizzes, only: %i[new create show update] do
    member do
      get 'results'
    end
  end
  root 'quizzes#new'
end
