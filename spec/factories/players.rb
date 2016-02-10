FactoryGirl.define do
  factory :player do
    after(:build) do |player|
      FactoryGirl.create(:stat, player: player) unless player.stat
    end
  end
end
