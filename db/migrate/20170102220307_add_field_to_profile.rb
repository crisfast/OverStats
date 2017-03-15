class AddFieldToProfile < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :platform, :string
  end
end
