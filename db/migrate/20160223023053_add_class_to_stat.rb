class AddClassToStat < ActiveRecord::Migration
  def change
    add_column :stats, :character_class, :string
  end
end
