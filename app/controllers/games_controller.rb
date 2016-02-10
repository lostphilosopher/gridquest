class GamesController < ApplicationController
  before_action :set_engine, only: [:edit]

  def index
  end

  def new
    grid = Grid.first
    stat = Stat.create(base_health: 10, base_attack: 5, base_defense: 5, current_health: 10)
    player = Player.create(
      name: current_user.email,
      current_box_id: grid.find_by_coordinates(1,1).id,
      stat: stat
    )
    game = Game.create(grid: grid, player: player)

    return redirect_to game_path(id: game.id)
  end

  def show
    @game = Game.find(params[:id])
    @box = Box.find(@game.player.current_box_id)
  end

  def edit
    game = Game.find(params[:id])
    action = params[:game_action]
    player = game.player

    # Movement
    player.move(action) if ('nsew'.include? action)

    # Combat
    @engine.battle(player, player.box.npc) if (('a' == action) && player.box.npc)

    return redirect_to game_path(id: game.id)
  end

  private

  def set_engine
    @engine = SimpleEngine.new
  end
end
