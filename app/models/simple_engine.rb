class SimpleEngine
  def battle(player, npc)
    # Player vs NPC
    damage = player.stat.base_attack - npc.stat.base_defense
    resulting_health = [0, npc.stat.current_health - damage].max
    npc.stat.update(current_health: resulting_health) if damage > 0
    return if resulting_health == 0

    # If NPC survives NPC vs Player
    damage = npc.stat.base_attack - player.stat.base_defense
    resulting_health = [0, player.stat.current_health - damage].max
    player.stat.update(current_health: resulting_health) if damage > 0
  end
end
