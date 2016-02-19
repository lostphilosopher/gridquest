class AddXpToStat < ActiveRecord::Migration
  def change
    add_column :stats, :xp, :integer, default: 0
  end
end
