class Player < ActiveRecord::Base
  belongs_to :game

  has_one :stat

  after_save :mark_current_box_explored

  def move(direction)
    update_position_by_direction(direction) if self.box.paths.include? direction
  end

  def update_position_by_direction(direction)
    x = Box.find(current_box_id).x
    y = Box.find(current_box_id).y

    case direction
    when 'n'
      y = y + 1
    when 's'
      y = y - 1
    when 'e'
      x = x + 1
    when 'w'
      x = x - 1
    else
    end

    new_box = self.game.grid.find_by_coordinates(x, y)
    self.update(current_box_id: new_box.id)
  end

  def box
    Box.find(current_box_id)
  end

  private

  def mark_current_box_explored
    box.update(explored: true) if current_box_id && !box.explored?
  end
end
