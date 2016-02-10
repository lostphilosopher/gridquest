class Player < ActiveRecord::Base
  belongs_to :game

  has_one :stat

  has_many :items

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
    update(current_box_id: new_box.id)
  end

  def box
    Box.find(current_box_id)
  end

  def take_items(items)
    items.each do |item|
      item.update(player: self, current_box_id: nil, equipped: true)
    end
  end

  def equipped_items
    Item.where(player: self, equipped: true)
  end

  private

  def mark_current_box_explored
    box.update(explored: true) if current_box_id && !box.explored?
  end
end
