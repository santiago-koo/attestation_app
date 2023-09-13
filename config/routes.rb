# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper scope: 'api/v1/sessions' do
    skip_controllers :authorizations, :applications, :authorized_applications, :token_info
  end

  namespace :api do
    namespace :v1 do
      scope :sessions, controller: 'sessions' do
        post :signin
        post :signout
      end
      scope :registrations, controller: 'registrations' do
        post :signup
      end
      resources :user_challenges, only: %i[index show create]
      resources :payments, only: %i[create]
    end
  end
end
