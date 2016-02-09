class CreateBoxes < ActiveRecord::Migration
  def change
    create_table :boxes do |t|
      t.integer :x
      t.integer :y
      t.string :paths
      t.boolean :explored

      t.timestamps null: false
    end
  end
end
