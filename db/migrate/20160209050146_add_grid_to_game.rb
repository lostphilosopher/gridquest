class AddGridToGame < ActiveRecord::Migration
  def change
    add_reference :grids, :game, index: true
  end
end
