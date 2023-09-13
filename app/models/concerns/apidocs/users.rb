# frozen_string_literal: true

module Apidocs
  module Users
    extend ActiveSupport::Concern

    included do
      include Swagger::Blocks

      swagger_schema :CreateRegistration do
        key :required, %i[email password]

        property :user do
          property :email do
            key :type, :string
            key :format, :email
          end

          property :password do
            key :type, :string
          end
        end
      end

      swagger_schema :UserTokenResponse do
        property :status do
          property :code do
            key :type, :string
          end
          property :message do
            key :type, :string
          end
        end

        property :data do
          property :user do
            property :id do
              key :type, :integer
            end
            property :email do
              key :type, :string
            end
          end
          property :tokens do
            property :token do
              key :type, :string
            end
            property :refresh_token do
              key :type, :string
            end
            property :expires_in do
              key :type, :integer
            end
            property :created_at do
              key :type, :integer
            end
          end
        end
      end
    end
  end
end
