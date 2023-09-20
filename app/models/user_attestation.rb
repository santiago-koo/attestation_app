# frozen_string_literal: true

# == Schema Information
#
# Table name: user_attestations
#
#  id                :bigint           not null, primary key
#  user_challenge_id :bigint           not null
#  receipt           :string           not null
#  public_key        :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class UserAttestation < ApplicationRecord
  belongs_to :user_challenge
end
