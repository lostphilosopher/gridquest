class AddMetaToUser < ActiveRecord::Migration
  def change
    add_reference :meta, :user, index: true
  end
end
