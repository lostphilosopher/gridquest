class GamesController < ApplicationController
  before_action :set_engine, only: [:edit]

  def index
    @game = Game.find_by(user: current_user)
  end

  def new
    destroy_previous_game
    game = setup_new_game

    return redirect_to game_path(id: game.id)
  end

  def show
    return redirect_to games_path unless @game = Game.find_by(id: params[:id])
    @box = Box.find(@game.player.current_box_id)

    return redirect_to victory_game_path(id: @game.id) if @game.victory?
    return redirect_to defeat_game_path(id: @game.id) if @game.defeat?
  end

  # @todo REFACTOR!!!
  def edit
    return redirect_to games_path unless @game = Game.find_by(id: params[:id])
    game = @game
    action = params[:game_action]
    item_id = params[:item_id]
    player = game.player

    take_game_action(item_id, action, player)

    player.box.effect.fire(player) if (player.box.effect? && !player.box.effect.stat.dead?)

    # Has a victory or loss condition been meet? - Handle Meta
    current_user.meta.increment_wins if game.victory?
    current_user.meta.add_to_xp(player.stat.xp.to_i) if (game.victory? || player.stat.dead?)
    return redirect_to defeat_game_path(id: game.id) if player.stat.dead?
    return redirect_to victory_game_path(id: game.id) if game.victory?

    # Continue Game
    return redirect_to game_path(id: game.id, anchor: 'gametop')
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

  # :nocov:
  def setup_new_game
    # Populate grid and boxes
    grid = Grid.create(width: 10, length: 10)

    number_of_elements = grid.elements_by_size
    grid.add_npcs(number_of_elements)
    grid.add_items(number_of_elements)

    victory_box = grid.victory_box
    description = Description.create(
      name: 'Skeleton Key',
      text: 'This key will open the door to your nightmares.'
    )
    Item.create_key(grid, description, victory_box.id)
    description = Description.create(
      name: 'Famine',
      text: 'A horseman of the Apocolypse.',
      url: 'https://static.pexels.com/photos/1555/black-and-white-flight-man-person-large.jpg',
      file_path: 'Famine'
    )
    Npc.create_boss(grid, description, victory_box.id)

    Effect::CLASSES.each do |type|
      effect = Effect.create(grid: grid, current_box_id: grid.random_clear_box.id)
      effect.of_type(type)
    end

    game = Game.create(grid: grid, user: current_user)
    player = game.build_a_player
    game.update(player: player)

    # Sanity Check Game
    # @todo Better version of this...
    game.sane? ? game.write_note('Your journey begins.') : game.write_note('Something is wrong, please start a new game.')

    # Meta
    current_user.meta.increment_games_played

    game
  end

  def take_game_action(item_id = nil, action = nil, player = nil)
    if player.box.possible_actions(item_id).include? action
      if action == 'run'
        @engine.run(player, player.box.npc)
      elsif 'nsew'.include? action
        player.move(action)
      elsif SimpleEngine::COMBAT_ACTIONS.include? action
        @engine.battle(action, player, player.box.npc)
      elsif 't' == action
        player.take_item(Item.find(item_id))
      elsif 'd' == action
        player.drop_item(Item.find(item_id))
      elsif 'i' == action
        item = Item.find(item_id)
        item.update(equipped: !item.equipped?)
      end
    end
  end
  # :nocov:

  def set_engine
    case current_user.game.player.stat.character_class
    when 'attack'
      @engine = Attack.new
    when 'defense'
      @engine = Defense.new
    when 'speed'
      @engine = Speed.new
    else
      @engine = SimpleEngine.new
    end
  end

  private

  def destroy_previous_game
    Game.where(user: current_user).destroy_all
  end
end
