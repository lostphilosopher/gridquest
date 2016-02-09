class Box < ActiveRecord::Base
  belongs_to :grid
  belongs_to :player

  after_create :populate_default_paths

  def paths_from_grid_boundaries
    paths = ''
    paths << 'n' if y < grid.length
    paths << 's' if y > 1
    paths << 'e' if x < grid.width
    paths << 'w' if x > 1

    paths
  end

  private

  def populate_default_paths
    update(paths: paths_from_grid_boundaries)
  end
end
