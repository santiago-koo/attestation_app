class AddIsAttestedToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_attested, :boolean, default: false, null: false
  end
end
