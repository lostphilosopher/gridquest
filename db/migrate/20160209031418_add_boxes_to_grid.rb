class AddBoxesToGrid < ActiveRecord::Migration
  def change
    add_reference :boxes, :grid, index: true
  end
end
