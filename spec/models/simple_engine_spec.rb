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

  # describe '.battle' do
  #   it 'if the player wins in the first round they wont be damaged and the npc will be beaten' do
  #     player.stat.update(base_attack: 10000)
  #     @foo.battle(SimpleEngine::COMBAT_ACTIONS[1], player, npc)
  #
  #     expect(player.stat.current_health).to eq 1
  #     expect(npc.stat.current_health).to eq 0
  #   end
  #   it "if the player doesn't win in the first round they will take damage" do
  #     base_health = 10000
  #     player.stat.update(base_health: base_health, current_health: base_health)
  #     npc.stat.update(current_health: base_health, base_attack: 5)
  #     @foo.battle(SimpleEngine::COMBAT_ACTIONS[1], player, npc)
  #
  #     expect(player.stat.current_health).to be < player.stat.base_health
  #   end
  # end

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

  describe 'first_striker' do
    9.times do
      it 'returns either the player or the npc' do
        actual = @foo.first_striker(SimpleEngine::COMBAT_ACTIONS[1], player, npc)
        expected = [player, npc]
        expect(expected).to include actual
      end
    end
  end

  describe '#items_health_modifier' do
    let!(:item_1) { FactoryGirl.create(:item) }
    let!(:item_2) { FactoryGirl.create(:item) }
    let(:items) { [item_1, item_2] }
    it 'adds the base stat from each item' do
      expected = item_1.stat.base_health + item_2.stat.base_health
      expect(SimpleEngine.items_health_modifier(items)).to eq expected
    end
  end

  describe '#items_attack_modifier' do
    let!(:item_1) { FactoryGirl.create(:item) }
    let!(:item_2) { FactoryGirl.create(:item) }
    let(:items) { [item_1, item_2] }
    it 'adds the base stat from each item' do
      expected = item_1.stat.base_attack + item_2.stat.base_attack
      expect(SimpleEngine.items_attack_modifier(items)).to eq expected
    end
  end

  describe '#items_defense_modifier' do
    let!(:item_1) { FactoryGirl.create(:item) }
    let!(:item_2) { FactoryGirl.create(:item) }
    let(:items) { [item_1, item_2] }
    it 'adds the base stat from each item' do
      expected = item_1.stat.base_defense + item_2.stat.base_defense
      expect(SimpleEngine.items_defense_modifier(items)).to eq expected
    end
  end

  describe '.run' do
    let!(:grid) { FactoryGirl.create(:grid) }
    let!(:box) { Box.first }
    it 'puts the player on a new square' do
      player.update(
        current_box_id: box.id
      )
      player.stat.update(
        current_health: 100000
      )
      old_box_id = player.current_box_id
      @foo.run(player, npc)
      expect(player.current_box_id).not_to eq old_box_id
    end
  end
end
