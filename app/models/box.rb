class Box < ActiveRecord::Base
  belongs_to :grid
  belongs_to :player

  has_one :description, dependent: :destroy

  after_create :populate_default_paths
  after_create :populate_default_descriptions

  def paths_from_grid_boundaries
    paths = ''
    paths << 'n' if y < self.grid.length
    paths << 's' if y > 1
    paths << 'e' if x < self.grid.width
    paths << 'w' if x > 1

    paths
  end

  def explored?
    explored
  end

  def locked?
    locked
  end

  def npc
    Npc.find_by(current_box_id: self.id)
  end

  def item
    Item.find_by(current_box_id: self.id)
  end

  def items
    Item.where(current_box_id: self.id)
  end

  def display_character(show_player = true)
    if (self.id == self.grid.game.player.current_box_id) && show_player
      '@'
    elsif explored? && locked?
      'L'
    elsif !explored?
      '?'
    elsif self.npc && !self.npc.stat.dead?
      'E'
    elsif !self.item.nil?
      'I'
    else
      'X'
    end
  end

  def find_by_current_and_direction(current_box_id, direction)
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

    self.grid.find_by_coordinates(x, y)
  end

  private

  def populate_default_paths
    update(paths: paths_from_grid_boundaries)
  end

  def populate_default_descriptions
    description = Description.create(Description.pick_from_json('box'))
    update(description: description)
  end
end
