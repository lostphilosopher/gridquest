# Must expose battle
class SimpleEngine < Engine
  BASE_NUMBER = 20

  COMBAT_ACTIONS = %w(heavy_attack quick_attack defend)

  # @todo: @player @npc

  # :nocov:
  def battle(action, player, npc)
    # Determine order of combat
    combatant_1 = first_striker(action, player, npc)
    combatant_2 = (player.id == combatant_1.id) ? npc : player

    # Fight!
    round(combatant_1, combatant_2)
    # Award XP
    award_xp(player, npc)

    return if combatant_2.stat.current_health == 0

    # If the second to strike is stil around, give them the opportunity
    round(combatant_2, combatant_1)
    # Award XP
    award_xp(player, npc)
  end
  # :nocov:

  def award_xp(player, npc)
    return unless npc.stat.dead?
    player.stat.update(xp: (npc.stat.level.to_i + player.stat.xp.to_i))
  end

  def round(combatant_1, combatant_2)
    # combatant_1 always strikes first
    damage = SimpleEngine.attack(combatant_1) - SimpleEngine.defense(combatant_2)
    resulting_health = [0, combatant_2.stat.current_health - damage].max
    combatant_2.stat.update(current_health: resulting_health) if damage > 0
  end

  def first_striker(action, player, npc)
    #@todo: Ensure that player and npc are Player and Npc instances
    # Rock, Paper, Scissors
    npc_action = pick_npc_action
    if action == COMBAT_ACTIONS[npc_action]
      # @todo: How to handle draw???
      #        - retry?
      #        - player? npc?
      #        - higher base_attack?
      first_striker(action, player, npc)
    elsif action == COMBAT_ACTIONS[npc_action - 1]
      return npc
    else
      return player
    end
  end

  def run(player, npc)
    npc_action = pick_npc_action
    round(npc, player) if 'quick_attack'
    player.run
  end

  private

  def pick_npc_action
    rand(3)
  end

  def self.attack(character)
    [0, character.stat.base_attack + SimpleEngine.items_attack_modifier(character.equipped_items)].max
  end

  def self.defense(character)
    [0, character.stat.base_defense + SimpleEngine.items_defense_modifier(character.equipped_items)].max
  end

  def self.items_health_modifier(items)
    base = 0
    items.each do |i|
      base += i.stat.base_health
    end
    base
  end

  def self.items_attack_modifier(items)
    base = 0
    items.each do |i|
      base += i.stat.base_attack
    end
    base
  end

  def self.items_defense_modifier(items)
    base = 0
    items.each do |i|
      base += i.stat.base_defense
    end
    base
  end
end
