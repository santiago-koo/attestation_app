# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Apple::UserChallengeService do
  describe '#call' do
    let(:service) { described_class.call(params) }

    context 'when user is not present' do
      let(:params) { { device_id: 'test@test.com', current_user: nil } }

      it 'returns success? false' do
        expect(service.success?).to be_falsey
        expect(service.payload).to include(message: 'User not found')
      end
    end

    context 'when user is present' do
      let(:user) { create(:user, :with_oauth_access_tokens, :with_user_challenges) }
      let(:params) { { device_id: user.user_challenges.last.device_id, current_user: user } }

      context 'and the last user_challenge is still active' do
        it 'returns success? true and the last user_challenge' do
          expect(service.success?).to be_truthy
          expect(service.payload).to eq(user.user_challenges.last)
          expect(user.user_challenges.count).to eq(1)
        end
      end

      context 'and the last user_challenge is still active but with expires_at grather than actual time' do
        it 'creates new user_challenge and deactivate old user_challenge' do
          user

          Timecop.freeze(Time.zone.now + 12.minutes) do
            expect { service }.to change { user.user_challenges.reload.count }.from(1).to(2).and change {
                                                                                                   user.user_challenges.reload.first.is_active
                                                                                                 }.from(true).to(false)

            expect(service.success?).to be_truthy
          end
        end
      end
    end
  end
end
