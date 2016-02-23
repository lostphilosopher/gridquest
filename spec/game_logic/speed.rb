require 'rails_helper'

RSpec.describe Speed, type: :model do
  let!(:player) { FactoryGirl.create(:player, stat: FactoryGirl.create(:stat, base_attack: 10, base_defense: 10)) }

  before do
    @foo = Speed.new
  end

  describe '.run' do
    let!(:grid) { FactoryGirl.create(:grid) }
    let!(:game) { FactoryGirl.create(:game, grid: grid, player: player) }
    let!(:npc) { FactoryGirl.create(:npc) }
    it 'moves the player to a new box unharmed' do
      player.update(current_box_id: grid.random_clear_box.id)
      old = player.current_box_id
      @foo.run(player, npc)
      expect(player.current_box_id).not_to eq old
    end
  end

  describe '.first_striker' do
    let!(:npc) { FactoryGirl.create(:npc) }
    it { expect(@foo.first_striker(SimpleEngine::COMBAT_ACTIONS[1], player, npc)).to eq player }
  end

  describe '#defense' do
    it { expect(Speed.defense(player)).to be >= 10 }
  end

  describe '#attack' do
    it { expect(Speed.attack(player)).to be >= 10 }
  end
end
