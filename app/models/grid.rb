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

  def elements_by_size(scale = 1)
    num = scale * ([length, width].min)
    num.round
  end

  def add_npcs(number)
    number.times do
      Npc.create(grid: self)
    end
  end

  def add_items(number)
    number.times do
      Item.create(grid: self)
    end
  end

  def random_clear_box
    x = rand(1..width)
    y = rand(1..length)
    box = find_by_coordinates(x, y)
    if box.player? || box.npc? || box.locked? || box.item?
      random_clear_box
    else
      box
    end
  end

  def victory_box
    return Box.find(victory_box_id) if victory_box_id

    victory_box = random_clear_box
    victory_box.update(locked: true)
    update(victory_box_id: victory_box.id)
    victory_box
  end

  private

  def populate_grid
    (1..self.length).each do |l|
      (1..self.width).each do |w|
        Box.create(x: w, y: l, grid: self)
      end
    end
  end
end
