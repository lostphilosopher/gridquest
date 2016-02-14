class AddEndingToGame < ActiveRecord::Migration
  def change
    add_column :games, :defeat_description_id, :integer
    add_column :games, :victory_description_id, :integer
  end
end
