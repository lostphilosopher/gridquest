class CreateDescriptions < ActiveRecord::Migration
  def change
    create_table :descriptions do |t|
      t.string :name
      t.string :text
      t.string :url
      t.string :background_color
      t.timestamps null: false
    end
  end
end
