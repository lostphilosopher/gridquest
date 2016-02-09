class AddDescriptionToNpc < ActiveRecord::Migration
  def change
    add_reference :descriptions, :npc, index: true
    add_reference :npcs, :grid, index: true
  end
end
