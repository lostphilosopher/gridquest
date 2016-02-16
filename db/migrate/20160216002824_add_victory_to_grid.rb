class AddVictoryToGrid < ActiveRecord::Migration
  def change
    add_column :grids, :victory_box_id, :integer
  end
end
