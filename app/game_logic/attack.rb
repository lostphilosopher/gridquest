class Attack < SimpleEngine
  private

  def self.attack(character)
    max_attack = self.max_attack(character) + rand(1..5)
    rand(character.stat.base_attack..max_attack)
  end
end
