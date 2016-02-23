require 'rails_helper'

RSpec.describe Stat, type: :model do
  let(:stat) { FactoryGirl.create(:stat) }

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
