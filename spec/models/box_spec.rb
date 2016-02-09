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
end
