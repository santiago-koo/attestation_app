# == Schema Information
#
# Table name: user_challenges
#
#  id          :bigint           not null, primary key
#  user_id     :bigint           not null
#  token       :string
#  device_id   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  is_active   :boolean          default(FALSE), not null
#  expires_at  :datetime
#  type_status :integer          default("empty")
#
class UserChallenge < ApplicationRecord
  enum type_status: { empty: 0, attestation: 1, assertion: 2, google_play_integrity: 3 }

  belongs_to :user
  has_one :user_attestation, dependent: :destroy

  scope :active, -> { where(is_active: true) }
end
