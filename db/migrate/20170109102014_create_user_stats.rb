class CreateUserStats < ActiveRecord::Migration[5.0]
  def change
    create_table :user_stats do |t|
      t.integer :user_id
      t.text :achievements
      t.text :profile
      t.text :statsAcc
      t.text :heroes

      t.timestamps
    end
  end
end
