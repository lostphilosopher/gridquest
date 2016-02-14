class AddXpToStat < ActiveRecord::Migration
  def change
    add_column :stats, :xp, :integer
  end
end
