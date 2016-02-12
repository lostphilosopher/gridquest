class Box < ActiveRecord::Base
  belongs_to :grid
  belongs_to :player

  has_one :description

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

  def npc
    Npc.find_by(current_box_id: self.id)
  end

  def items
    Item.where(current_box_id: self.id)
  end

  def display_character
    if self.id == self.grid.game.player.current_box_id
      '@'
    elsif !explored?
      '?'
    elsif self.npc && !self.npc.stat.dead?
      'E'
    elsif !self.items.empty?
      'I'
    else
      'X'
    end
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
