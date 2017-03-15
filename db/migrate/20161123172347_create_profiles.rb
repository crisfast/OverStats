class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.string :region
      t.string :battletag

      t.timestamps
    end
  end
end
