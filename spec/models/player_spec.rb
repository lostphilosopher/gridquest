require 'rails_helper'

RSpec.describe Player, type: :model do
  let!(:grid) { FactoryGirl.create(:grid) }

  describe '.box' do
    let!(:box) { FactoryGirl.create(:box, grid: grid) }
    let!(:player) { FactoryGirl.create(:player, current_box_id: box.id) }
    it 'returns the box identified by the current_box_id' do
      expect(player.box.id).to eq box.id
    end
  end

  describe '.update_position_by_direction_direction' do
    let!(:box) { grid.boxes.first }
    let!(:player) { FactoryGirl.create(:player, current_box_id: box.id) }
    let!(:game) { FactoryGirl.create(:game, grid: grid, player: player) }

    before do
      player.update(current_box_id: grid.find_by_coordinates(2, 2).id)
    end

    context 'moving north' do
      it 'increases y' do
        player.update_position_by_direction('n')
        expect(player.box.x).to eq 2
        expect(player.box.y).to eq 3
      end
    end
    context 'moving south' do
      it 'decreases y' do
        player.update_position_by_direction('s')
        expect(player.box.x).to eq 2
        expect(player.box.y).to eq 1
      end
    end
    context 'moving east' do
      it 'increases x' do
        player.update_position_by_direction('e')
        expect(player.box.x).to eq 3
        expect(player.box.y).to eq 2
      end
    end
    context 'moving west' do
      it 'decreases x' do
        player.update_position_by_direction('w')
        expect(player.box.x).to eq 1
        expect(player.box.y).to eq 2
      end
    end
  end

  describe '.move' do
    let!(:box) { FactoryGirl.create(:box, grid: grid) }
    let!(:player) { FactoryGirl.create(:player, current_box_id: grid.find_by_coordinates(1,1).id) }
    let!(:game) { FactoryGirl.create(:game, grid: grid, player: player) }

    context 'with a valid direction' do
      it 'updates the player\'s current_box_id' do
        player.move('n')
        expect(player.current_box_id).to eq grid.find_by_coordinates(1,2).id
      end
    end
  end

  describe '.take_items' do
    let!(:player) { FactoryGirl.create(:player) }
    let!(:item) { FactoryGirl.create(:item) }
    it "equips the item in the player's inventory" do
      player.take_items([item])
      expect(player.equipped_items).to include item
    end
  end

  describe '.run' do
    let!(:grid) { FactoryGirl.create(:grid) }
    let(:box) { Box.first }
    let!(:player) { FactoryGirl.create(:player, current_box_id: box.id) }
    it 'moves the player anywhere other than where they are' do
      old_position = player.current_box_id
      player.run
      expect(player.current_box_id).not_to eq old_position
    end
  end

  describe '.random_path' do
    let!(:grid) { FactoryGirl.create(:grid) }
    let(:box) { Box.first }
    let!(:player) { FactoryGirl.create(:player, current_box_id: box.id) }
    it { expect('nsew').to include player.random_path }
  end
end
