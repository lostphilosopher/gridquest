class AddNotesToGame < ActiveRecord::Migration
  def change
    add_reference :notes, :game, index: true
  end
end
