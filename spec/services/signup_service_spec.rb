# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SignupService do
  describe '#call' do
    let(:service) { described_class.call(params) }

    context 'when the user signup' do
      before do
        allow(::SigninService).to receive(:call).with({ email: params[:email],
                                                        password: params[:password] }).and_return(signin_service_instance)
        allow(signin_service_instance).to receive(:payload).and_return(signin_service_payload)
      end

      let(:params) { { email: 'test@test.com', password: 'password' } }
      let(:signin_service_instance) { double(::SigninService) }
      let(:signin_service_payload) { { user: nil, tokens: { access_token: '1234', refresh_token: '4321' } } }

      it 'description' do
        expect(service.success?).to be_truthy
        expect(User.count).to eq(1)
      end
    end
  end
end
