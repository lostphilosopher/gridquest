class CreateEffects < ActiveRecord::Migration
  def change
    create_table :effects do |t|
      t.integer :current_box_id
      t.timestamps null: false
    end
  end
end
