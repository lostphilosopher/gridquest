class Item < ActiveRecord::Base
  has_one :stat
  has_one :description
  belongs_to :player
  belongs_to :npc
  belongs_to :grid

  after_create :place_on_grid

  def equipped?
    self.equipped
  end

  def place_on_grid
    return unless self.grid
    return if (self.player || self.npc || equipped?)
    grid = self.grid
    current_box_id = grid.find_by_coordinates(rand(1..grid.width), rand(1..grid.length)).id
    update(current_box_id: current_box_id) if Box.find(current_box_id).items.empty?
  end
end
