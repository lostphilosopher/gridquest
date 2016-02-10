class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.integer :base_health
      t.integer :base_attack
      t.integer :base_defense
      t.integer :current_health
      t.timestamps null: false
    end
  end
end
