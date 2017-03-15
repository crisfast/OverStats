class CreateGuestStats < ActiveRecord::Migration[5.0]
  def change
    create_table :guest_stats do |t|
      t.text :battletag
      t.text :region
      t.text :profile
      t.text :heroes
      
      t.timestamps
    end
  end
end
