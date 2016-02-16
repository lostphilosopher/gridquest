class Player < ActiveRecord::Base
  belongs_to :game

  has_one :stat, dependent: :destroy

  has_many :items, dependent: :destroy

  after_save :mark_current_box_explored

  MAX_ITEMS = 2

  def run
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
      new_box.update(explored: true)
      return
    end
    update(current_box_id: new_box.id)
  end

  def box
    Box.find(current_box_id)
  end

  def take_item(item)
    item.update(player: self, current_box_id: nil, equipped: false)
  end

  def equipped_items
    Item.where(player: self, equipped: true)
  end

  def inventory_full?
    equipped_items.count >= MAX_ITEMS
  end

  private

  def mark_current_box_explored
    box.update(explored: true) if current_box_id && !box.explored?
  end
end
