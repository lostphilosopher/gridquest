class AddDescStatToItemAndItemToPlayerAndNpc < ActiveRecord::Migration
  def change
    add_reference :items, :player, index: true
    add_reference :items, :npc, index: true
    add_reference :items, :grid, index: true
    add_reference :descriptions, :item, index: true
    add_reference :stats, :item, index: true
  end
end
