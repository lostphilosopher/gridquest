require 'rails_helper'

RSpec.describe Effect, type: :model do
  let!(:stat) { FactoryGirl.create(:stat, current_health: 7, base_health: 20) }
  let!(:player) { FactoryGirl.create(:player, stat: stat) }
  let!(:grid) { FactoryGirl.create(:grid) }
  let!(:game) { FactoryGirl.create(:game, grid: grid, player: player) }
  let!(:heal_effect) do
    e = FactoryGirl.create(:effect, grid: grid)
    e.of_type('heal')
    e
  end
  let!(:hurt_effect) do
    e = FactoryGirl.create(:effect, grid: grid)
    e.of_type('hurt')
    e
  end
  let!(:teleport_effect) do
    e = FactoryGirl.create(:effect, grid: grid)
    e.of_type('teleport')
    e
  end

  describe '.of_type' do
    it { expect(heal_effect.stat.character_class).to eq 'heal' }
    it { expect(hurt_effect.stat.character_class).to eq 'hurt' }
    it { expect(teleport_effect.stat.character_class).to eq 'teleport' }
  end

  describe '.fire' do
    context 'for a heal effect' do
      it 'restores the players health' do
        old = player.stat.current_health
        heal_effect.fire(player)
        expect(player.stat.current_health).to be > old
      end
    end
    context 'for a hurt effect' do
      it 'damages the players health' do
        old = player.stat.current_health
        hurt_effect.fire(player)
        expect(player.stat.current_health).to be < old
      end
    end
    context 'for a teleport effect' do
      it 'damages the players health' do
        player.update(current_box_id: Box.first.id)
        old = player.current_box_id
        teleport_effect.fire(player)
        expect(player.current_box_id).not_to eq old
      end
    end
  end
end
