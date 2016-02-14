class Stat < ActiveRecord::Base
  belongs_to :player
  belongs_to :npc
  belongs_to :stat

  def level
    ((base_health + base_attack + base_defense)/3).to_i
  end

  def dead?
    (self.current_health == 0)
  end
end
