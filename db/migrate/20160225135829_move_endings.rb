class MoveEndings < ActiveRecord::Migration
  def change
    remove_column :games, :victory_description_id
    remove_column :games, :defeat_description_id

    add_column :grids, :victory_description_id, :integer
    add_column :grids, :defeat_description_id, :integer
  end
end
