require 'rails_helper'

RSpec.describe Stat, type: :model do
  let(:stat) { FactoryGirl.create(:stat) }
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
