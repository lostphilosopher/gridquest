class Game < ActiveRecord::Base
  has_one :grid, dependent: :destroy
  has_one :player, dependent: :destroy

  has_many :notes, dependent: :destroy

  belongs_to :user

  after_create :default_endings

  def write_note(text)
    Note.create(game: self, text: text)
  end

  def recent_notes
    notes.sort_by(&:created_at).last(10).reverse
  end

  def victory?
    box_id = grid.victory_box_id
    box = Box.find(box_id)
    box.npc.stat.dead?
  end

  def defeat?
    player.stat.dead?
  end

  def default_endings
    v = Description.create(Description.pick_from_json('victory')).id
    d = Description.create(Description.pick_from_json('defeat')).id
    update(victory_description_id: v, defeat_description_id: d)
  end
end
