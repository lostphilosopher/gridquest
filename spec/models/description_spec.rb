require 'rails_helper'

RSpec.describe Description, type: :model do
  describe 'pick_from_json' do
    context 'box' do
      ["name", "url", "text", "file_path"].each do |elem|
        it { expect(Description.pick_from_json('box')).to have_key elem }
        it { expect(Description.pick_from_json('box')[elem]).to be_instance_of String }
      end
    end
    context 'npc' do
      ["name", "url", "text", "file_path"].each do |elem|
        it { expect(Description.pick_from_json('npc')).to have_key elem }
        it { expect(Description.pick_from_json('npc')[elem]).to be_instance_of String }
      end
    end
    context 'item' do
      ["name", "text"].each do |elem|
        it { expect(Description.pick_from_json('item')).to have_key elem }
        it { expect(Description.pick_from_json('item')[elem]).to be_instance_of String }
      end
    end
    context 'key' do
      ["name", "text"].each do |elem|
        it { expect(Description.pick_from_json('key')).to have_key elem }
        it { expect(Description.pick_from_json('key')[elem]).to be_instance_of String }
      end
    end
  end

  describe '.image' do
    let!(:grid) { FactoryGirl.create(:grid) }
    let!(:npc) { FactoryGirl.create(:npc) }
    let!(:item) { FactoryGirl.create(:item) }
    let!(:description) { FactoryGirl.create(:description) }

    context 'box description' do
      it { expect(grid.boxes.first.description.image).to match(/box\/[A-Za-z0-9]*.jpg/) }
    end
    context 'npc description' do
      it 'provides a formatted file_path' do
        npc.update(description: description)
        expect(npc.description.image).to match(/npc\/[A-Za-z0-9]*.jpg/)
      end
    end
    context 'item description' do
      it 'provides a formatted file_path' do
        item.update(description: description)
        expect(item.description.image).to match(/item\/[A-Za-z0-9]*.jpg/)
      end
    end
  end
end
