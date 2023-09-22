class AddIsActiveAndExpiresAtToUserChallenges < ActiveRecord::Migration[7.0]
  def change
    add_column :user_challenges, :is_active, :boolean, default: false, null: false
    add_column :user_challenges, :expires_at, :datetime
  end
end
