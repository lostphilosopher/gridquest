require 'rails_helper'

RSpec.describe SimpleEngine, type: :model do
  let!(:stat_1) { FactoryGirl.create(:stat, base_attack: 10, base_defense: 0, current_health: 1) }
  let!(:stat_2) { FactoryGirl.create(:stat, base_attack: 10, base_defense: 0, current_health: 1) }
  let!(:player) { FactoryGirl.create(:player, stat: stat_1) }
  let!(:npc) { FactoryGirl.create(:npc, stat: stat_2) }

  before do
    @foo = SimpleEngine.new
  end

  describe '#BASE_NUMBER' do
    it { expect(SimpleEngine::BASE_NUMBER).to eq 20 }
  end

  describe '.battle' do
    it 'if the player wins in the first round they wont be damaged and the npc will be beaten' do
      player.stat.update(base_attack: 10000)
      @foo.battle(player, npc)

      expect(player.stat.current_health).to eq 1
      expect(npc.stat.current_health).to eq 0
    end
    it "if the player doesn't win in the first round they will take damage" do
      base_health = 10000
      player.stat.update(base_health: base_health, current_health: base_health)
      npc.stat.update(current_health: base_health, base_attack: 5)
      @foo.battle(player, npc)

      expect(player.stat.current_health).to be < player.stat.base_health
    end
  end

  describe '.round' do
    it 'if the player strikes first they win' do
      player.stat.update(base_attack: 10000)
      @foo.round(player, npc)
      expect(npc.stat.current_health).to eq 0
    end
    it 'if the npc strikes first they win' do
      npc.stat.update(base_attack: 10000)
      @foo.round(npc, player)
      expect(player.stat.current_health).to eq 0
    end
  end
end
