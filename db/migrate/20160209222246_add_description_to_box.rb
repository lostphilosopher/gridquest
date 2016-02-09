class AddDescriptionToBox < ActiveRecord::Migration
  def change
    add_reference :descriptions, :box, index: true
  end
end
