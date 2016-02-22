class Npc < ActiveRecord::Base
  has_one :description, dependent: :destroy
  has_one :stat, dependent: :destroy
  has_many :items

  belongs_to :grid

  after_create :populate_default_descriptions_and_stats
  after_create :place_on_grid

  def box
    return unless current_box_id
    Box.find(current_box_id)
  end

  def equipped_items
    Item.where(npc: self, equipped: true)
  end

  def self.create_boss(grid, description, box_id)
    npc = create(grid: grid)
    npc.update(description: description, current_box_id: box_id)
    health = rand(10..20)
    npc.stat.update(
      base_health: health, 
      base_attack: rand(10..20),
      base_defense: rand(10..20),
      current_health: health
    )
  end

  private

  def populate_default_descriptions_and_stats
    description = Description.create(Description.pick_from_json('npc'))
    health = rand(1..20)
    stat = Stat.create(
      base_health: health,
      current_health: health,
      base_attack: rand(1..20),
      base_defense: rand(1..20)
    )
    update(description: description, stat: stat)
  end

  def place_on_grid
    return unless grid
    current_box_id = grid.find_by_coordinates(rand(1..grid.width), rand(1..grid.length)).id
    update(current_box_id: current_box_id) unless Box.find(current_box_id).npc
  end
end
