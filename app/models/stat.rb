class Stat < ActiveRecord::Base
  belongs_to :player
  belongs_to :npc
  belongs_to :stat
  belongs_to :effect

  def character_class_description
    case character_class
    when 'defense'
      'This character gets a bonus to defense.'
    when 'attack'
      'This character gets a bonus to attack'
    when 'speed'
      'This character gets a bonus to running, and first strike'
    else
      'This character has no special bonuses.'
    end
  end

  def level
    ((base_health + base_attack + base_defense)/3).to_i
  end

  def dead?
    (self.current_health == 0)
  end
end
