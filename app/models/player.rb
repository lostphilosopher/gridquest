class Player < ActiveRecord::Base
  belongs_to :game

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
end
