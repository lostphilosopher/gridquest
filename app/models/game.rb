class Game < ActiveRecord::Base
  has_one :grid, dependent: :destroy
  has_one :player, dependent: :destroy

  belongs_to :user

  after_create :default_endings

  def default_endings
    v = Description.create(Description.pick_from_json('victory')).id
    d = Description.create(Description.pick_from_json('defeat')).id
    update(victory_description_id: v, defeat_description_id: d)
  end
end
