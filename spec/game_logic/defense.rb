require 'rails_helper'

RSpec.describe Defense, type: :model do
  let!(:player) { FactoryGirl.create(:player, stat: FactoryGirl.create(:stat, base_defense: 10)) }

  describe '#defense' do
    it { expect(Defense.defense(player)).to be >= 10 }
  end
end
