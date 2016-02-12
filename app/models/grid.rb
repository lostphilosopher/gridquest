class Grid < ActiveRecord::Base
  has_many :boxes, dependent: :destroy
  has_many :npcs, dependent: :destroy
  has_many :items, dependent: :destroy
  belongs_to :game

  after_create :populate_grid

  def find_by_coordinates(x_cord, y_cord)
    Box.find_by(
      grid: self,
      x: x_cord,
      y: y_cord
    )
  end

  def box_exists?(x_cord, y_cord)
    find_by_coordinates(x_cord, y_cord).present?
  end

  private

  def populate_grid
    (1..self.length).to_a.each do |l|
      (1..self.width).to_a.each do |w|
        Box.create(x: w, y: l, grid: self)
      end
    end
  end
end
