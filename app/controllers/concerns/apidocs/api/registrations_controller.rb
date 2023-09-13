# frozen_string_literal: true

module Apidocs
  module Api
    module RegistrationsController
      extend ActiveSupport::Concern

      included do
        include Swagger::Blocks

        swagger_path '/api/v1/registrations/signup' do
          operation :post do
            key :summary, 'Creates a new user'
            key :description, 'Create a new user with the given data'
            key :tags, ['Registrations']
            key :operationId, 'createRegistration'

            parameter do
              key :name, :user
              key :in, :body
              key :description, 'User to be created'
              key :required, true
              schema do
                key :'$ref', :CreateRegistration
              end
            end

            response 200 do
              key :description, 'ok'
              schema do
                key :'$ref', :UserTokenResponse
              end
            end
            response 401 do
              key :description, 'not authorized'
            end
          end
        end
      end
    end
  end
end
