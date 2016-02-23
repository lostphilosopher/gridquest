require 'rails_helper'

RSpec.describe Attack, type: :model do
  let!(:player) { FactoryGirl.create(:player, stat: FactoryGirl.create(:stat, base_attack: 10)) }

  describe '#attack' do
    it { expect(Attack.attack(player)).to be >= 10 }
  end
end
