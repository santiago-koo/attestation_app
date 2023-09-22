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
require "test_helper"

class UserChallengeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
