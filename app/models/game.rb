class Game < ActiveRecord::Base
  has_one :grid
  has_one :player
end
