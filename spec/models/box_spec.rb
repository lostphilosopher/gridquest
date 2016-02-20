require 'rails_helper'

RSpec.describe Box, type: :model do
  describe 'paths_from_grid_boundaries' do
    let!(:grid) { FactoryGirl.create(:grid, length: 3, width: 3) }
    context 'when the current box is in the bottom left corner (1,1)' do
      it 'returns "ne"' do
        box = Box.create(x:1, y: 1, grid: grid)
        expect(box.paths_from_grid_boundaries).to eq 'ne'
      end
    end
    context 'when the current box is in the upper right corner (3,3)' do
      it 'returns "ne"' do
        box = Box.create(x:3, y: 3, grid: grid)
        expect(box.paths_from_grid_boundaries).to eq 'sw'
      end
    end
    context 'when the current box is in center (2,2)' do
      it 'returns "ne"' do
        box = Box.create(x:2, y: 2, grid: grid)
        expect(box.paths_from_grid_boundaries).to eq 'nsew'
      end
    end
  end

  describe '.explored?' do
    let!(:grid) { FactoryGirl.create(:grid) }
    let!(:explored_box) { FactoryGirl.create(:box, explored: true, grid: grid) }
    let!(:unexplored_box) { FactoryGirl.create(:box, explored: false, grid: grid) }
    it 'wraps and returns the boolean of explored' do
      expect(explored_box.explored?).to eq true
      expect(unexplored_box.explored?).to eq false
    end
  end

  describe '.locked?' do
    let!(:grid) { FactoryGirl.create(:grid) }
    let!(:locked_box) { FactoryGirl.create(:box, locked: true, grid: grid) }
    let!(:unlocked_box) { FactoryGirl.create(:box, locked: false, grid: grid) }
    it 'wraps and returns the boolean of locked' do
      expect(locked_box.locked?).to eq true
      expect(unlocked_box.locked?).to eq false
    end
  end

  describe '.npc' do
    let!(:grid) { FactoryGirl.create(:grid) }
    let(:box) { Box.first }
    context 'with an npc present' do
      before { FactoryGirl.create(:npc, current_box_id: box.id) }
      it { expect(box.npc).to be_instance_of Npc }
    end
    context 'without an npc present' do
      it { expect(box.npc).to be nil }
    end
  end

  describe '.item' do
    let!(:grid) { FactoryGirl.create(:grid) }
    let(:box) { Box.first }
    context 'with an item present' do
      before { FactoryGirl.create(:item, current_box_id: box.id) }
      it { expect(box.item).to be_instance_of Item }
    end
    context 'without an item present' do
      it { expect(box.item).to eq nil }
    end
  end

  describe '.items' do
    let!(:grid) { FactoryGirl.create(:grid) }
    let(:box) { Box.first }
    context 'with items present' do
      before do
        FactoryGirl.create(:item, current_box_id: box.id)
        FactoryGirl.create(:item, current_box_id: box.id)
        FactoryGirl.create(:item, current_box_id: box.id)
      end
      it { expect(box.items.count).to eq 3 }
      it { expect(box.items.first).to be_instance_of Item }
    end
    context 'without any items present' do
      it { expect(box.items).to be_empty }
    end
  end

  describe '.display_character' do
    let!(:grid) { FactoryGirl.create(:grid, length: 3, width: 3) }
    let!(:box) { Box.first }
    let!(:player) { FactoryGirl.create(:player, current_box_id: box.id) }
    let!(:game) { FactoryGirl.create(:game, player: player, grid: grid) }

    before do
      player.update(current_box_id: nil)
    end

    context 'when the player is present' do
      before do
        player.update(current_box_id: box.id)
      end
      it { expect(box.display_character).to eq '@' }
    end

    context 'when the player knows the box is locked' do
      before do
        box.update(explored: true, locked: true)
      end
      it { expect(box.display_character).to eq 'L' }
    end

    context 'when the player knows an enemy is present' do
      before do
        FactoryGirl.create(:npc, current_box_id: box.id)
        box.update(explored: true)
      end
      it { expect(box.display_character).to eq 'E' }
    end

    context 'when the player knows an item is present' do
      before do
        FactoryGirl.create(:item, current_box_id: box.id)
        box.update(explored: true)
      end
      it { expect(box.display_character).to eq 'I' }
    end

    context 'when the box is explored and empty' do
      before do
        box.update(explored: true)
      end
      it { expect(box.display_character).to eq 'X' }
    end

    context 'when the box is unexplored' do
      before do
        player.update(current_box_id: nil)
      end
      it { expect(box.display_character).to eq '?' }
    end
  end
end
