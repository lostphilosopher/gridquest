class AddFilepathToDescription < ActiveRecord::Migration
  def change
    add_column :descriptions, :file_path, :string
  end
end
