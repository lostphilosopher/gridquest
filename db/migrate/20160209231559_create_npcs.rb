class CreateNpcs < ActiveRecord::Migration
  def change
    create_table :npcs do |t|
      t.integer :current_box_id
      t.timestamps null: false
    end
  end
end
