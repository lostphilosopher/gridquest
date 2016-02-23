class Defense < SimpleEngine
  private

  def self.defense(character)
    max_defense = self.max_defense(character) + rand(1..5)
    rand(character.stat.base_defense..max_defense)
  end
end
