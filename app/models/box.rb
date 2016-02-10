class Box < ActiveRecord::Base
  belongs_to :grid
  belongs_to :player

  has_one :description

  after_create :populate_default_paths

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

  private

  def populate_default_paths
    update(paths: paths_from_grid_boundaries)
  end
end
