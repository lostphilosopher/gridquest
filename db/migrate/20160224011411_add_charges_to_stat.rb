class AddChargesToStat < ActiveRecord::Migration
  def change
    add_column :stats, :charges, :integer, default: 0
  end
end
