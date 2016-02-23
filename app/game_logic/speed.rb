class Speed < SimpleEngine
  def run(player, npc)
    player.game.write_note("Running.")
    player.run
  end

  def first_striker(action, player, npc)
    player
  end

  private

  def self.defense(character)
    max_defense = self.max_defense(character) + 1
    rand(character.stat.base_defense..max_defense)
  end

  def self.attack(character)
    max_attack = self.max_attack(character) + 1
    rand(character.stat.base_attack..max_attack)
  end
end
