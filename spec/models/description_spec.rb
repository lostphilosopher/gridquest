require 'rails_helper'

RSpec.describe Description, type: :model do
  describe 'pick_from_json' do
    it "has the keys needed for a description object" do
      ["name", "url", "text"].each do |elem|
        expect(Description.pick_from_json('box')).to have_key elem
      end
    end
    it "provides accessible strings" do
      ["name", "url", "text"].each do |elem|
        expect(Description.pick_from_json('box')[elem]).to be_instance_of String
      end
    end
  end
end
