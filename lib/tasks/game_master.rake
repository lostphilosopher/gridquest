namespace :game_master do
  desc 'Wipe out all active games'
  task reset_games: :environment do
    Game.delete_all
  end
end
