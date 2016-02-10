class Description < ActiveRecord::Base
  belongs_to :box
  belongs_to :npc
  belongs_to :item
end
