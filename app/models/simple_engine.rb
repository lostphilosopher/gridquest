# Must expose battle
class SimpleEngine < Engine
  BASE_NUMBER = 20

  COMBAT_ACTIONS = %w(heavy_attack quick_attack defend)

  # @todo: @player @npc

  # :nocov:
  def battle(action, player, npc)
    player.game.write_note("Entering combat with #{npc.description.name}.")

    # Determine order of combat
    combatant_1 = first_striker(action, player, npc)
    combatant_2 = (player.id == combatant_1.id) ? npc : player

    if combatant_1 == player
      player.game.write_note("You strike first.")
    else
      player.game.write_note("#{npc.description.name} strikes first.")
    end

    # Fight!
    round(combatant_1, combatant_2, player)
    # Award XP
    award_xp(player, npc)

    return if combatant_2.stat.current_health == 0

    if combatant_1 == player
      player.game.write_note("#{npc.description.name} strikes back.")
    else
      player.game.write_note("You strike back.")
    end


    # If the second to strike is stil around, give them the opportunity
    round(combatant_2, combatant_1, player)
    # Award XP
    award_xp(player, npc)
  end
  # :nocov:

  def award_xp(player, npc)
    return unless npc.stat.dead?
    xp_gained = npc.stat.level.to_i
    total = (xp_gained + player.stat.xp.to_i)
    player.stat.update(xp: total)

    player.game.write_note("#{xp_gained} XP gained.")

    # Meta
    player.game.user.meta.increment_kills
  end

  # @todo Refactor using @vars
  def round(combatant_1, combatant_2, player)
    # combatant_1 always strikes first
    damage = [0, (SimpleEngine.attack(combatant_1) - SimpleEngine.defense(combatant_2))].max

    # :nocov:
    if critical?
      damage = damage * 2
      player.game.write_note('Critical hit.')
    end
    # :nocov:

    if combatant_2 == player
      player.game.write_note("#{damage} damage done to you.")
    else
      player.game.write_note("#{damage} damage done to #{combatant_2.description.name}.")
    end

    resulting_health = [0, combatant_2.stat.current_health - damage].max

    puts combatant_2.id == player.id ? "=== Player ===" : "=== Npc ==="
    puts "=== #{resulting_health} ==="

    if resulting_health == 0
      player.game.write_note("#{combatant_2.description.name} is killed.") if combatant_2 != player
      player.game.write_note("You are killed.") if combatant_2 == player
    end

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
    round(npc, player, player) if 'quick_attack' == COMBAT_ACTIONS[npc_action]
    player.run
  end

  private

  def pick_npc_action
    rand(3)
  end

  def self.attack(character)
    max_attack = self.max_attack(character)
    rand(character.stat.base_attack..max_attack)
  end

  def self.max_attack(character)
    [0, character.stat.base_attack + SimpleEngine.items_attack_modifier(character.equipped_items)].max
  end

  def self.defense(character)
    max_defense = self.max_defense(character)
    rand(character.stat.base_defense..max_defense)
  end

  def self.max_defense(character)
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
