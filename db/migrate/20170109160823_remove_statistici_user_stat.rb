class RemoveStatisticiUserStat < ActiveRecord::Migration[5.0]
  def change
    remove_column :user_stats, :statsAcc
  end
end
