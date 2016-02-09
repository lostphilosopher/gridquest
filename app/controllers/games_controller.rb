class GamesController < ApplicationController
  def index
  end

  def new
    grid = Grid.first
    player = Player.create(
      name: current_user.email,
      current_box_id: grid.find_by_coordinates(1,1).id
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
    game.player.move(action) if 'nsew'.include? action

    return redirect_to game_path(id: game.id)
  end
end
