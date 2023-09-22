class AddTypeToUserChallenges < ActiveRecord::Migration[7.0]
  def change
    add_column :user_challenges, :type_status, :integer, default: 0
  end
end
