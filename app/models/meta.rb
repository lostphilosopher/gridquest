class Meta < ActiveRecord::Base
  belongs_to :user

  def increment_games_played
    update(games_played: games_played + 1)
  end
  def increment_wins
    update(wins: wins + 1)
  end
  def increment_kills
    update(kills: kills + 1)
  end
  def add_to_xp(additional_xp)
    update(xp: xp + additional_xp)
  end
end
