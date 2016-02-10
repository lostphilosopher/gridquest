class Box < ActiveRecord::Base
  belongs_to :grid
  belongs_to :player

  has_one :description

  after_create :populate_default_paths

  def paths_from_grid_boundaries
    paths = ''
    paths << 'n' if y < grid.length
    paths << 's' if y > 1
    paths << 'e' if x < grid.width
    paths << 'w' if x > 1

    paths
  end

  def explored?
    explored
  end

  def npc
    npc = Npc.find_by(current_box_id: self.id)
    npc unless npc.dead?
  end

  private

  def populate_default_paths
    update(paths: paths_from_grid_boundaries)
  end
end
