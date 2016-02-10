# Must expose battle
class SimpleEngine < Engine
  BASE_NUMBER = 20

  def battle(player, npc)
    # Player vs NPC
    round(player, npc)
    return if npc.stat.current_health == 0

    # If NPC survives NPC vs Player
    round(npc, player)
  end

  def round(combatant_1, combatant_2)
    # combatant_1 always strikes first
    damage = SimpleEngine.attack(combatant_1.stat) - SimpleEngine.defense(combatant_2.stat)
    resulting_health = [0, combatant_2.stat.current_health - damage].max
    combatant_2.stat.update(current_health: resulting_health) if damage > 0
  end

  private

  def self.attack(stat)
    stat.base_attack + 0
  end

  def self.defense(stat)
    stat.base_defense + 0
  end
end
