class Npc < ActiveRecord::Base
  has_one :description, dependent: :destroy
  has_one :stat, dependent: :destroy
  has_many :items

  belongs_to :grid

  after_create :populate_default_descriptions
  after_create :place_on_grid

  def box
    return unless self.current_box_id
    Box.find(current_box_id)
  end

  def equipped_items
    Item.where(npc: self, equipped: true)
  end

  private

  def populate_default_descriptions
    description = Description.create(Description.pick_from_json('npc'))
    health = rand(1..10)
    stat = Stat.create(base_health: health, current_health: health, base_attack: rand(1..10), base_defense: rand(1..10))
    update(description: description, stat: stat)
  end

  def place_on_grid
    return unless self.grid
    grid = self.grid
    current_box_id = grid.find_by_coordinates(rand(1..grid.width), rand(1..grid.length)).id
    update(current_box_id: current_box_id) unless Box.find(current_box_id).npc
  end
end
