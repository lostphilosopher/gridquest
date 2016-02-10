class SimpleEngine
  def battle(player, npc)
    # Player vs NPC
    damage = SimpleEngine.attack(player.stat) - SimpleEngine.defense(npc.stat)
    resulting_health = [0, npc.stat.current_health - damage].max
    npc.stat.update(current_health: resulting_health) if damage > 0
    return if resulting_health == 0

    # If NPC survives NPC vs Player
    damage = SimpleEngine.attack(npc.stat) - SimpleEngine.defense(player.stat)
    resulting_health = [0, player.stat.current_health - damage].max
    player.stat.update(current_health: resulting_health) if damage > 0
  end

  private

  def self.attack(stat)
    stat.base_attack + 0
  end

  def self.defense(stat)
    stat.base_defense + 0
  end
end
