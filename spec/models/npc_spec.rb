require 'rails_helper'

RSpec.describe Npc, type: :model do
  let!(:grid) { FactoryGirl.create(:grid) }
  let!(:npc) { FactoryGirl.create(:npc, grid: grid) }

  describe '.box' do
    it { expect(npc.box).to be_instance_of Box }
  end

  describe '.equipped_items' do
    before do
      item_1 = FactoryGirl.create(:item, grid: grid, equipped: true)
      item_2 = FactoryGirl.create(:item, grid: grid, equipped: true)
      npc.update(items: [item_1, item_2])
    end
    it { expect(npc.equipped_items.count).to eq 2 }
    it { expect(npc.equipped_items.first).to be_instance_of Item }
  end

  describe '.populate_default_descriptions' do
    it { expect(npc.description).to be_instance_of Description }
  end

  describe '.place_on_grid' do
    it { expect(Box.find(npc.current_box_id)).to be_instance_of Box }
  end
end
