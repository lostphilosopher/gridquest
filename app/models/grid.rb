class Grid < ActiveRecord::Base
  has_many :boxes
  has_many :npcs
  has_many :items
  belongs_to :game

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
end
