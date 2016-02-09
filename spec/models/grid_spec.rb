require 'rails_helper'

RSpec.describe Grid, type: :model do
  let!(:grid) { FactoryGirl.create(:grid) }
  describe '.box_exists?' do
    it 'returns true if the box exists in the grid' do
      Box.create(grid: grid, x: 7, y: 7)

      expect(grid.box_exists?(7,7)).to eq true
    end

    it 'returns false if the box does not exist in the grid' do
      expect(grid.box_exists?(7,7)).to eq false
    end
  end
end
