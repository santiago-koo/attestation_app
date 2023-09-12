class CreateUserChallenges < ActiveRecord::Migration[7.0]
  def change
    create_table :user_challenges do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token
      t.string :device_id

      t.timestamps
    end
  end
end
