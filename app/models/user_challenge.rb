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
#
class UserChallenge < ApplicationRecord
  belongs_to :user
end
