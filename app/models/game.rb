class Game < ActiveRecord::Base
  has_one :grid, dependent: :destroy
  has_one :player, dependent: :destroy

  has_many :notes, dependent: :destroy

  belongs_to :user

  after_create :default_endings

  def write_note(text)
    return if text.empty?
    Note.create(game: self, text: text)
  end

  def recent_notes
    notes.sort_by(&:created_at).last(10).reverse
  end

  def victory?
    box_id = grid.victory_box_id
    box = Box.find(box_id)
    raise "No enemy on victory_box_id #{box_id} for game #{id}" unless box.npc
    box.npc.stat.dead?
  end

  def defeat?
    player.stat.dead?
  end

  def default_endings
    v = Description.create(Description.pick_from_json('victory')).id
    d = Description.create(Description.pick_from_json('defeat')).id
    grid.update(victory_description_id: v, defeat_description_id: d)
  end

  # @todo Add description
  def build_a_player
    Player.create(
      name: 'Player 1',
      current_box_id: grid.random_clear_box.id,
      stat: Stat.create(
              character_class: SimpleEngine::CLASSES[rand(1..3)],
              base_health: 10,
              base_attack: rand(1..10),
              base_defense: rand(1..10),
              current_health: 10,
              charges: 2
            )
    )
  end

  def sane?
    return false unless (grid && grid.victory_box_id)
    victory_box_id = grid.victory_box_id
    return false unless Box.find(victory_box_id)
    victory_box = Box.find(victory_box_id)
    return false unless (victory_box.npc? && victory_box.locked?)
    return false unless Item.find_by(opens_box_id: victory_box)

    true
  end
end
