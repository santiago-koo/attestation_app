class CreateUserAttestations < ActiveRecord::Migration[7.0]
  def change
    create_table :user_attestations do |t|
      t.references :user_challenge, null: false, foreign_key: true
      t.string :receipt, null: false
      t.string :public_key, niull: false

      t.timestamps
    end
  end
end
