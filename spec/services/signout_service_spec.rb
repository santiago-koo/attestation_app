# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SignoutService do
  describe '#call' do
    let(:service) { described_class.call(params) }
    let(:user) { create(:user, :with_oauth_access_tokens) }

    context 'when the user signout' do
      let(:params) { { current_user: user } }

      it 'oauth_access_tokens are deleted' do
        expect(service.success?).to be_truthy
        expect(user.oauth_access_tokens.count).to eq(0)
      end
    end
  end
end
