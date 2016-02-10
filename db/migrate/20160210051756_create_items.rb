class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.boolean :equipped
      t.integer :current_box_id
      t.timestamps null: false
    end
  end
end
