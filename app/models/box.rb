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

  def player?
    (self.grid && self.grid.game && self.grid.game.player && (self.grid.game.player.current_box_id = id))
  end

  def npc?
    npc ? true : false
  end

  def item?
    item ? true : false
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

  def player
    grid.game.player if grid && grid.game && grid.game.player
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

  def possible_actions(item_id = nil)
    actions = []
    actions << 'run'
    if player.box.npc && !player.box.npc.stat.dead?
      actions << SimpleEngine::COMBAT_ACTIONS
    else
      actions << 'n' if paths.include? 'n'
      actions << 's' if paths.include? 's'
      actions << 'e' if paths.include? 'e'
      actions << 'w' if paths.include? 'w'
    end
    if Item.find_by(id: item_id)
      actions << 't' if player.box.item && !player.inventory_full?
      actions << 'd' if !player.items.empty? && !Item.find(item_id).key?
      actions << 'i' if !player.items.empty?
    end
    actions
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
