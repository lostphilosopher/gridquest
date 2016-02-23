class AddStatAndDescToEffect < ActiveRecord::Migration
  def change
    add_reference :stats, :effect, index: true
    add_reference :descriptions, :effect, index: true
    add_reference :effects, :grid, index: true
  end
end
