class CreateMeta < ActiveRecord::Migration
  def change
    create_table :meta do |t|
      t.integer :xp, default: 0
      t.integer :games_played, default: 0
      t.integer :wins, default: 0
      t.integer :kills, default: 0

      t.timestamps null: false
    end
  end
end
