class Item < ActiveRecord::Base
  has_one :stat, dependent: :destroy
  has_one :description, dependent: :destroy
  belongs_to :player
  belongs_to :npc
  belongs_to :grid

  after_create :populate_default_descriptions
  after_create :place_on_grid

  def equipped?
    self.equipped
  end

  private

  def populate_default_descriptions
    description = Description.create(Description.pick_from_json('item'))
    health = rand(1..10)
    stat = Stat.create(base_health: health, current_health: health, base_attack: rand(1..10), base_defense: rand(1..10))
    update(description: description, stat: stat)
  end

  def place_on_grid
    return unless self.grid
    return if (self.player || self.npc || equipped?)
    grid = self.grid
    current_box_id = grid.find_by_coordinates(rand(1..grid.width), rand(1..grid.length)).id
    update(current_box_id: current_box_id) if Box.find(current_box_id).items.empty?
  end
end
