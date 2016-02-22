require 'rails_helper'

RSpec.describe Engine, type: :model do
  before do
    @foo = Engine.new
  end

  describe '#BASE_NUMBER' do
    it { expect(Engine::BASE_NUMBER).to be_instance_of Fixnum }
  end

  describe '.critical?' do
    it { expect(@foo.critical?).to be_in([true, false]) }
  end
end
