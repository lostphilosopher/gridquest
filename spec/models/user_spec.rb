require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:admin_user) { FactoryGirl.create(:user, email: 'wandersen02@gmail.com') }
  let!(:user) { FactoryGirl.create(:user) }

  describe '.admin?' do
    it { expect(admin_user.admin?).to eq true }
    it { expect(user.admin?).to eq false }
  end

  describe '.add_meta_to_user' do
    it { expect(user.meta).to be_instance_of Meta }
  end
end
