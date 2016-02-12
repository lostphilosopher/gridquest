class Game < ActiveRecord::Base
  has_one :grid, dependent: :destroy
  has_one :player, dependent: :destroy

  belongs_to :user
end
