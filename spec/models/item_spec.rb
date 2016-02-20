require 'rails_helper'

RSpec.describe Item, type: :model do
  let!(:grid) { FactoryGirl.create(:grid) }
  let!(:item) { FactoryGirl.create(:item, grid: grid) }
  let!(:box) { Box.second }

  describe '.key?' do
    let!(:key_item) { FactoryGirl.create(:item, opens_box_id: box.id, grid: grid) }
    let!(:non_key_item) { FactoryGirl.create(:item, grid: grid) }
    it { expect(key_item.key?).to eq true }
    it { expect(non_key_item.key?).to eq false }
  end

  describe '.equipped?' do
    let!(:equipped_item) {FactoryGirl.create(:item, equipped: true, grid: grid)}
    let!(:unequipped_item) {FactoryGirl.create(:item, equipped: false, grid: grid)}
    it { expect(equipped_item.equipped?).to eq true }
    it { expect(unequipped_item.equipped?).to eq false }
  end

  describe '.populate_default_descriptions' do
    it 'assigns stats and descriptions to the item' do
      expect(item.stat).to be_instance_of Stat
      expect(item.description).to be_instance_of Description
    end
  end

  describe '.place_on_grid' do
    it 'assigns a box to the item' do
      expect(Box.find(item.current_box_id)).to be_instance_of Box
    end
  end
end
