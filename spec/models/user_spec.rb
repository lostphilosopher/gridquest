require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:admin_user) { FactoryGirl.create(:user, email: 'wandersen02@gmail.com') }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:grid) { FactoryGirl.create(:grid) }

  describe '.admin?' do
    it { expect(admin_user.admin?).to eq true }
    it { expect(user.admin?).to eq false }
  end

  describe '.add_meta_to_user' do
    it { expect(user.meta).to be_instance_of Meta }
  end

  describe '.build_a_player_for_game' do
    let!(:game) { FactoryGirl.create(:game, grid: grid) }
    it { expect(user.build_a_player_for_game(game)).to be_instance_of Player }
  end
end
