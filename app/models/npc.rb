class Npc < ActiveRecord::Base
  has_one :description
  has_one :stat

  belongs_to :grid

  after_create :place_on_grid

  def box
    return unless self.current_box_id
    Box.find(current_box_id)
  end

  private

  def place_on_grid
    return unless self.grid
    grid = self.grid
    current_box_id = grid.find_by_coordinates(rand(1..grid.width), rand(1..grid.length)).id
    update(current_box_id: current_box_id) unless Box.find(current_box_id).npc
  end
end
