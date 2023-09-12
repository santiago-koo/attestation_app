# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper scope: 'api/v1/sessions' do
    skip_controllers :authorizations, :applications, :authorized_applications
  end

  namespace :api do
    namespace :v1 do
      resources :sessions, only: %i[create destroy]
      resources :registrations, only: %i[create]
      resources :payments, only: %i[create]
    end
  end
end
