class Stat < ActiveRecord::Base
  belongs_to :player
  belongs_to :npc

  def dead?
    (self.current_health == 0)
  end
end
