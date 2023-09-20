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
require 'rails_helper'

RSpec.describe UserAttestation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
