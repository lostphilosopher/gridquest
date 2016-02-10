require 'rails_helper'

RSpec.describe Npc, type: :model do
  let!(:grid) { FactoryGirl.create(:grid) }
  let!(:npc) { FactoryGirl.create(:npc, current_box_id: Box.first.id) }

  describe '.box' do
    it { expect(npc.box).to eq Box.first }
  end

  describe '.place_on_grid' do
    let(:npc) { FactoryGirl.create(:npc, grid: grid) }
    it { expect(npc.current_box_id).to be_instance_of Fixnum }
  end
end
