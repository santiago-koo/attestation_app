# frozen_string_literal: true

class ApidocsController < ActionController::Base
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'Attestation API Docs'
      key :description, 'Attestation API endpoints'
      key :termsOfService, ''
      contact do
        key :name, 'Attestation Team'
      end
      license do
        key :name, 'MIT'
      end
    end
    key :host, ENV['DOMAIN'] || 'localhost:3000'
    key :basePath, '/api/'
    key :consumes, ['application/json']
    key :produces, ['application/json']

    security_definition :api_key do
      key :type, :apiKey
      key :name, :Authorization
      key :in, :header
    end
  end

  SWAGGERED_CONTROLER_CLASSES = [
    Api::V1::RegistrationsController,
    self
  ]
  SWAGGERED_MODEL_CLASSES = [
    User
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CONTROLER_CLASSES + SWAGGERED_MODEL_CLASSES)
  end
end
