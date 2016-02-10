class AddStatToNpcAndPlayer < ActiveRecord::Migration
  def change
    add_reference :stats, :player, index: true
    add_reference :stats, :npc, index: true
  end
end
