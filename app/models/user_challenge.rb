# == Schema Information
#
# Table name: user_challenges
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  token      :string
#  device_id  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  is_active  :boolean          default(FALSE), not null
#
class UserChallenge < ApplicationRecord
  belongs_to :user
  has_one :user_attestation, dependent: :destroy

  scope :active, -> { where(is_active: true) }
end
