FactoryGirl.define do
  factory :npc do
    after(:build) do |npc|
      FactoryGirl.create(:stat, npc: npc) unless npc.stat
    end
  end
end
