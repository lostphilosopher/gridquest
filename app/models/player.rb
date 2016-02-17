class Player < ActiveRecord::Base
  belongs_to :game

  has_one :stat, dependent: :destroy

  has_many :items, dependent: :destroy

  after_save :mark_current_box_explored

  MAX_ITEMS = 5
  MAX_EQUIPPED = 2

  def run
    game.write_note("Running.")
    move(random_path)
  end

  def random_path
    self.box.paths.split(//).sample
  end

  def move(direction)
    update_position_by_direction(direction) if self.box.paths.include? direction
  end

  def update_position_by_direction(direction)
    new_box = box.find_by_current_and_direction(current_box_id, direction)
    # @todo This but better...
    if new_box.locked? && Item.where(player: self, opens_box_id: new_box.id).empty?
      game.write_note("Blocked at (#{new_box.x},#{new_box.y}), find the key.")
      new_box.update(explored: true)
      return
    elsif new_box.locked?
      game.write_note("(#{new_box.x},#{new_box.y}) unlocked.")
    end
    game.write_note("Moved #{direction_to_s(direction)}.")
    update(current_box_id: new_box.id)
  end

  def box
    Box.find(current_box_id)
  end

  def take_item(item)
    return if inventory_full?
    item.update(player: self, current_box_id: nil, equipped: false)
    game.write_note("Took #{item.description.name}.")
  end

  def drop_item(item)
    item.update(player: nil, current_box_id: box.id, equipped: false)
    game.write_note("Dropped #{item.description.name}.")
  end

  def equipped_items
    Item.where(player: self, equipped: true)
  end

  def fully_equipped?
    equipped_items.count >= MAX_EQUIPPED
  end

  def items_in_inventory
    Item.where(player: self)
  end

  def inventory_full?
    items_in_inventory.count >= MAX_ITEMS
  end

  def direction_to_s(direction)
    map = {
      'n' => 'North',
      's' => 'South',
      'e' => 'East',
      'w' => 'West'
    }
    map[direction]
  end

  private

  def mark_current_box_explored
    box.update(explored: true) if current_box_id && !box.explored?
  end
end
