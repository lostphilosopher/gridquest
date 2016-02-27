require 'rails_helper'

RSpec.describe Player, type: :model do
  let!(:grid) { FactoryGirl.create(:grid) }

  describe '.npc' do
    let!(:box) { FactoryGirl.create(:box, grid: grid) }
    let!(:player) { FactoryGirl.create(:player, current_box_id: box.id) }
    let!(:npc) { FactoryGirl.create(:npc, current_box_id: box.id) }

    it { expect(box.npc).to be_instance_of Npc }
  end

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

    context 'moving west, but box is locked player does not have key' do
      let(:before_box_id) { player.current_box_id }
      before do
        box = grid.find_by_coordinates(1, 2)
        box.update(locked: true)
      end
      it 'returns the player to their prior box' do
        player.update_position_by_direction('w')
        expect(player.box.id).to eq before_box_id
      end
    end

    context 'moving west, box is locked, but player does have key' do
      before do
        box = grid.find_by_coordinates(1, 2)
        box.update(locked: true)
        item = FactoryGirl.create(:item, opens_box_id: box.id)
        player.update(items: [item])
      end
      it 'moves the player into the locked box' do
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

  describe '.take_item' do
    let!(:player) { FactoryGirl.create(:player) }
    let!(:game) { FactoryGirl.create(:game, player: player, grid: grid) }
    let!(:item) { FactoryGirl.create(:item) }
    it "adds the item to the player's inventory" do
      player.take_item(item)
      expect(player.items).to include item
    end
  end

  describe '.run' do
    let(:box) { Box.first }
    let!(:player) { FactoryGirl.create(:player, current_box_id: box.id) }
    let!(:game) { FactoryGirl.create(:game, player: player, grid: grid) }
    it 'moves the player anywhere other than where they are' do
      old_position = player.current_box_id
      player.run
      expect(player.current_box_id).not_to eq old_position
    end
  end

  describe '.drop_item' do
    let(:box) { Box.first }
    let!(:player) { FactoryGirl.create(:player, current_box_id: box.id) }
    let!(:game) { FactoryGirl.create(:game, player: player, grid: grid) }
    let!(:item) { FactoryGirl.create(:item, grid: grid) }

    before do
      player.update(items: [item])
      player.drop_item(player.items.first)
    end

    it 'removes the item from the player\'s inventory' do
      expect(player.items.count).to eq 0
    end

    it 'places the item in the current box' do
      expect(item.current_box_id).to eq player.current_box_id
    end
  end

  describe '.equipped_items' do
    let!(:player) { FactoryGirl.create(:player) }
    let!(:item) { FactoryGirl.create(:item, grid: grid, equipped: true) }
    before do
      player.update(items: [item])
    end
    it { expect(player.equipped_items).to include item }
  end

  describe '.fully_equipped?' do
    let!(:player) { FactoryGirl.create(:player) }
    let!(:item_1) { FactoryGirl.create(:item, grid: grid, equipped: true) }
    let!(:item_2) { FactoryGirl.create(:item, grid: grid, equipped: true) }
    context 'not fully equipped' do
      before { player.update(items: [item_1]) }
      it { expect(player.fully_equipped?).to eq false }
    end
    context 'fully equipped' do
      before { player.update(items: [item_1, item_2]) }
      it { expect(player.fully_equipped?).to eq true }
    end
  end

  describe '.items_in_inventory' do
    let!(:player) { FactoryGirl.create(:player) }
    let!(:item_1) { FactoryGirl.create(:item, grid: grid, equipped: true) }
    let!(:item_2) { FactoryGirl.create(:item, grid: grid, equipped: true) }
    context 'with items' do
      before { player.update(items: [item_1, item_2]) }
      it { expect(player.items_in_inventory.count).to eq 2 }
      it { expect(player.items_in_inventory.first).to be_instance_of Item }
    end
    context 'without items' do
      before { player.update(items: []) }
      it { expect(player.items_in_inventory.count).to eq 0 }
    end
  end

  describe '.inventory_full?' do
    let!(:player) { FactoryGirl.create(:player) }

    before do
      4.times do
        FactoryGirl.create(:item, grid: grid, player: player)
      end
    end

    context 'full inventory' do
      before { FactoryGirl.create(:item, grid: grid, player: player) }
      it { expect(player.inventory_full?).to eq true }
    end
    context 'not full inventory' do
      it { expect(player.inventory_full?).to eq false }
    end
  end

  describe '.direction_to_s' do
    let!(:player) { FactoryGirl.create(:player) }

    it { expect(player.direction_to_s('n')).to eq 'North' }
    it { expect(player.direction_to_s('s')).to eq 'South' }
    it { expect(player.direction_to_s('e')).to eq 'East' }
    it { expect(player.direction_to_s('w')).to eq 'West' }
  end

  describe '.key?' do
    let!(:box) { Box.first }
    let!(:player) { FactoryGirl.create(:player) }
    let!(:item) { FactoryGirl.create(:item, opens_box_id: box.id) }

    context 'when the player has a key' do
      before { player.update(items: [item]) }
      it { expect(player.key?).to eq true }
    end
    context 'when the player does not have a key' do
      before { player.update(items: []) }
      it { expect(player.key?).to eq false }
    end
  end

  describe '.random_path' do
    let(:box) { Box.first }
    let!(:player) { FactoryGirl.create(:player, current_box_id: box.id) }
    it { expect('nsew').to include player.random_path }
  end

  describe '.mark_current_box_explored' do
    let!(:player) { FactoryGirl.create(:player) }

    before { player.update(current_box_id: Box.first.id) }

    it { expect(Box.find(player.current_box_id).explored?).to eq true }
  end
end
