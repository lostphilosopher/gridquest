class CreateGrids < ActiveRecord::Migration
  def change
    create_table :grids do |t|
      t.integer :length
      t.integer :width

      t.timestamps null: false
    end
  end
end
