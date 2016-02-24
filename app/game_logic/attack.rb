class Attack < SimpleEngine
  def self.attack(character)
    max_attack = self.max_attack(character) + rand(1..5)
    rand(character.stat.base_attack..max_attack)
  end

  def self.special(character)
    player = character
    if player.box.npc?
      npc = player.box.npc
      damage = (2 * Attack.attack(player))
      result = (npc.stat.current_health - damage)
      result = [0, result].max
      npc.stat.update(current_health: result)
      player.game.write_note("#{damage} damage done by special attack.")
    else
      player.game.write_note("No targets.")
    end
  end
end
