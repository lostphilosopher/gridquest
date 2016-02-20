require 'rails_helper'

RSpec.describe Grid, type: :model do
  let!(:grid) { FactoryGirl.create(:grid) }

  describe '.find_by_coordinates' do
    context 'when the box exists' do
      let(:box) { grid.find_by_coordinates(1,1) }
      it { expect(box).to be_instance_of Box }
    end

    context 'when the box does not exist' do
      let(:box) { grid.find_by_coordinates(99,99) }
      it { expect(box).to eq nil }
    end
  end

  describe '.populate_grid' do
    it 'creates boxes for each space on the grid' do
      expected = grid.length * grid.width
      expect(grid.boxes.count).to eq expected
    end
  end
end
