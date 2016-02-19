class GamesController < ApplicationController
  before_action :set_engine, only: [:edit]

  def index
    @game = Game.find_by(user: current_user)
  end

  # @todo REFACTOR!!!
  def new
    # Only one active game allowed
    destroy_previous_game

    # Populate grid and boxes
    grid = Grid.create(width: 10, length: 10)
    num = [grid.length, grid.width].min

    # Add NPCs to grid
    num.times do
      Npc.create(grid: grid)
    end

    # Add Items to grid
    num.times do
      Item.create(grid: grid)
    end

    # Create player
    stat = Stat.create(base_health: 10, base_attack: rand(1..10), base_defense: rand(1..10), current_health: 10)
    player = Player.create(
      name: current_user.email,
      current_box_id: grid.find_by_coordinates(1,1).id,
      stat: stat
    )

    # Set up the end room
    x = rand(2..grid.width)
    y = rand(2..grid.length)
    box = grid.find_by_coordinates(x, y)
    box.update(locked: true)
    grid.update(victory_box_id: box.id)
    d = Description.create(name: 'Skeleton Key', text: 'This key will open the door to your nightmares.')
    item = Item.create(grid: grid)
    item.update(description: d)
    item.update(opens_box_id: box.id)
    d = Description.create(name: 'Famine', text: 'A horseman of the Apocolypse.', url: 'https://static.pexels.com/photos/1555/black-and-white-flight-man-person-large.jpg', file_path: 'Famine')
    npc = Npc.create(grid: grid)
    npc.update(current_box_id: box.id, description: d)
    h = rand(10..20)
    npc.stat.update(base_health: h, base_attack: rand(10..20), base_defense: rand(10..20), current_health: h)
    # @todo Not this
    redirect_to new_game_path unless (box.locked? && box.npc && item.opens_box_id && item.current_box_id)

    # Create game with grid and player
    game = Game.create(grid: grid, player: player, user: current_user)
    game.write_note('Your journey begins.')

    # Meta
    current_user.meta.increment_games_played

    # Begin game
    return redirect_to game_path(id: game.id)
  end

  def show
    @game = Game.find(params[:id])
    @box = Box.find(@game.player.current_box_id)

    return redirect_to victory_game_path(id: @game.id) if @game.victory?
    return redirect_to defeat_game_path(id: @game.id) if @game.defeat?
  end

  # @todo REFACTOR!!!
  def edit
    game = Game.find(params[:id])
    action = params[:game_action]
    item_id = params[:item_id]
    player = game.player
    # @todo: Consider "GuaranteedAnimal"
    if player.box.npc && !player.box.npc.stat.dead?
      npc = player.box.npc
    else
      npc = nil
    end

    # Run away! Always an option.
    @engine.run(player, npc) if action == 'run'

    # Movement: Can only be done to vaild paths, and when enemies aren't present
    player.move(action) if (('nsew'.include? action) && npc.nil?)

    # Combat
    @engine.battle(action, player, player.box.npc) if ((SimpleEngine::COMBAT_ACTIONS.include? action) && npc)

    # Take/Drop item
    player.take_item(Item.find(item_id)) if (player.box.item && 't' == action && !player.inventory_full?)
    player.drop_item(Item.find(item_id)) if (!player.items.empty? && 'd' == action)

    # Equip / Unequip item
    # @todo method
    if params[:item_id] && action == 'i'
      item = Item.find(item_id)
      item.update(equipped: !item.equipped?)
    end

    # Has a victory or loss condition been meet?
    # Meta
    current_user.meta.increment_games_won if game.victory?
    current_user.meta.add_to_xp(player.stat.xp.to_i) if (game.victory? || player.stat.dead?)
    return redirect_to defeat_game_path(id: game.id) if player.stat.dead?
    return redirect_to victory_game_path(id: game.id) if game.victory?

    # Continue Game
    return redirect_to game_path(id: game.id)
  end

  def defeat
    return redirect_to games_path unless game = Game.find_by(id: params[:id])
    return redirect_to game_path(id: game.id) unless game.defeat?
    @message = Description.find(game.defeat_description_id).text
    @notes = game.recent_notes
  end

  def victory
    return redirect_to games_path unless game = Game.find_by(id: params[:id])
    return redirect_to game_path(id: game.id) unless game.victory?
    @message = Description.find(game.victory_description_id).text
    @notes = game.recent_notes
  end

  private

  def set_engine
    @engine = SimpleEngine.new
  end

  def destroy_previous_game
    Game.where(user: current_user).destroy_all
  end
end
