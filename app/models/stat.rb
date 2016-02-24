class Stat < ActiveRecord::Base
  belongs_to :player
  belongs_to :npc
  belongs_to :stat
  belongs_to :effect

  def special
    return unless charges?
    update(charges: charges - 1)
    case character_class
    when 'defense'
      update(current_health: base_health)
      player.game.write_note('Health restored by special ability.')
    when 'attack'
      Attack.special(player)
    when 'speed'
      box = player.game.grid.random_clear_box
      player.update(current_box_id: box.id)
      player.game.write_note("Special boosts you to (#{box.x},#{box.y}).")
    else
      # ...
    end
  end

  def charges?
    charges > 0
  end

  def character_class_description
    case character_class
    when 'defense'
      'This character gets a bonus to defense. Their special restores health.'
    when 'attack'
      'This character gets a bonus to attack. Their special deals double damage.'
    when 'speed'
      'This character gets a bonus to running, and first strike. Their special transports them to a random location.'
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
