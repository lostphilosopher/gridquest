require 'rails_helper'

RSpec.describe Stat, type: :model do
  let(:stat) { FactoryGirl.create(:stat, charges: 99) }
  let!(:grid) { FactoryGirl.create(:grid) }
  let(:box) { Box.first }
  let!(:player) { FactoryGirl.create(:player, stat: stat, current_box_id: box) }
  let!(:game) { FactoryGirl.create(:game, player: player, grid: grid) }

  describe '.special' do
    context 'player has no charges' do
      it { expect(stat.special).to eq nil }
    end
    context 'player has charges' do
      context 'defense' do
        before do
          player.stat.update(character_class: 'defense', current_health: 5, base_health: 10)
        end
        it 'restores current_health to base_health' do
          stat.special
          expect(player.stat.current_health).to eq player.stat.base_health
        end
      end
      context 'speed' do
        before { player.stat.update(character_class: 'speed') }
        let(:old) { player.current_box_id }
        it 'moves the player to a random box' do
          # @todo Wuuuuut...
          # player.stat.special
          # expect(player.current_box_id).not_to eq old
        end
      end
    end
  end

  describe '.character_class_description' do
    context 'defense' do
      before { stat.update(character_class: 'defense') }
      it { expect(stat.character_class_description).to match(/defense/) }
    end
    context 'attack' do
      before { stat.update(character_class: 'attack') }
      it { expect(stat.character_class_description).to match(/attack/) }
    end
    context 'speed' do
      before { stat.update(character_class: 'speed') }
      it { expect(stat.character_class_description).to match(/run/) }
    end
    context 'default' do
      before { stat.update(character_class: 'default') }
      it { expect(stat.character_class_description).to match(/no special/) }
    end
  end

  describe '.level' do
    it 'calculates the level by base stats' do
      stat.update(base_health: 4, base_attack: 5, base_defense: 6)
      expect(stat.level).to eq ((4 + 5 + 6)/3)
    end
  end

  describe '.dead?' do
    it 'when current_health == 0' do
      stat.update(current_health: 0)
      expect(stat.dead?).to eq true
    end
    it 'when current_health > 0' do
      stat.update(current_health: 1)
      expect(stat.dead?).to eq false
    end
  end
end
