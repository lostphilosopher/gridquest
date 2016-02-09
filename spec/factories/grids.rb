FactoryGirl.define do
  factory :grid do
    length 3
    width 3
    after(:build) do |grid|
      [1,2,3].each do |n|
        [1,2,3].each do |i|
          FactoryGirl.create(:box, x: n, y: i, grid: grid)
        end
      end
    end
  end
end
