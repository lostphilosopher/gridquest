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
    damage = SimpleEngine.attack(combatant_1) - SimpleEngine.defense(combatant_2)
    resulting_health = [0, combatant_2.stat.current_health - damage].max
    combatant_2.stat.update(current_health: resulting_health) if damage > 0
  end

  private

  def self.attack(character)
    [0, character.stat.base_attack + SimpleEngine.items_attack_modifier(character.equipped_items)].max
  end

  def self.defense(character)
    [0, character.stat.base_defense + SimpleEngine.items_defense_modifier(character.equipped_items)].max
  end

  def self.items_health_modifier(items)
    base = 0
    items.each do |i|
      base =+ i.stat.base_health
    end
    base
  end

  def self.items_attack_modifier(items)
    base = 0
    items.each do |i|
      base =+ i.stat.base_attack
    end
    base
  end

  def self.items_defense_modifier(items)
    base = 0
    items.each do |i|
      base =+ i.stat.base_defense
    end
    base
  end
end
