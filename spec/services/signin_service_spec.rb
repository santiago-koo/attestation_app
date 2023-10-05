# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SigninService do
  describe '#call' do
    let(:service) { described_class.call(params) }

    context 'when user does not exists' do
      let(:params) { { email: 'test@test.com', password: nil } }

      it 'raise ActiveRecord::RecordNotFound error' do
        expect { service }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when user exists' do
      let(:user) { create(:user) }

      context 'with the incorrect password' do
        let(:params) { { email: user.email, password: '123456789' } }

        it 'returns success? false' do
          expect(service.success?).to be_falsey
        end
      end

      context 'with the correct password' do
        let(:params) { { email: user.email, password: user.password } }

        it 'returns success? true with tokens data' do
          expect(service.success?).to be_truthy
          expect(service.payload[:user]).to eq(user)
          expect(service.payload[:tokens]).to include(:access_token, :refresh_token)
        end
      end
    end
  end
end
