class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :game
  has_one :meta

  after_create :add_meta_to_user

  def build_a_player_for_game(game)
    Player.create(
      name: email,
      current_box_id: game.grid.find_by_coordinates(1,1).id,
      stat:
        Stat.create(
            base_health: 10,
            base_attack: rand(1..10),
            base_defense: rand(1..10),
            current_health: 10
        )
    )
  end

  def admin?
    (email && (email == 'wandersen02@gmail.com'))
  end

  private

  def add_meta_to_user
    update(meta: Meta.create)
  end
end
