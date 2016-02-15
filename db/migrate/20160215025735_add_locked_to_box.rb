class AddLockedToBox < ActiveRecord::Migration
  def change
    add_column :boxes, :locked, :boolean, null: false, default: false
    add_column :items, :opens_box_id, :integer
  end
end
