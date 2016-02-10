require 'rails_helper'

RSpec.describe Engine, type: :model do
  before do
    @foo = Engine.new
  end

  describe '#BASE_NUMBER' do
    it { expect(Engine::BASE_NUMBER).to eq 100 }
  end

  describe '.critical?' do
    it { expect(@foo.critical?).to be_in([true, false]) }
  end
end
