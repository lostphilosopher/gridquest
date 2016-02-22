require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  let!(:user) { FactoryGirl.create(:user) }

  describe '#index' do
    context 'without a signed in user' do
      before do
        get :index
      end
      it { should respond_with :ok }
      it { should render_template 'index' }
    end
  end

  describe '#new' do
    let!(:grid) { FactoryGirl.create(:grid) }

    context 'with a signed in user' do
      before do
        sign_in user
        post :new
      end
      it { should respond_with :redirect }
      it { should redirect_to game_path(id: Game.first.id) }
    end
  end

  describe '#show' do
    let!(:grid) do
      grid = FactoryGirl.create(:grid)
      grid.update(victory_box_id: Box.second.id)
      FactoryGirl.create(:npc, current_box_id: Box.second.id)
      grid
    end
    let!(:player) { FactoryGirl.create(:player, current_box_id: Box.first.id) }
    let!(:game) { FactoryGirl.create(:game, grid: grid, player: player) }

    context 'with a signed in user and an ongoing game' do
      before do
        sign_in user
        get :show, id: game.id
      end
      it { should respond_with :ok }
      it { should render_template 'show' }
      it { expect(assigns(:game)).to eq game }
      it { expect(assigns(:box)).to eq player.box }
    end
    context 'with a signed in user and a beaten game' do
      before do
        player.update(current_box_id: Box.second.id)
        Box.second.npc.stat.update(current_health: 0)
        sign_in user
        get :show, id: game.id
      end
      it { should respond_with :redirect }
      it { should redirect_to victory_game_path }
      it { expect(assigns(:game)).to eq game }
    end
    context 'with a signed in user and a lost game' do
      before do
        player.stat.update(current_health: 0)
        sign_in user
        get :show, id: game.id
      end
      it { should respond_with :redirect }
      it { should redirect_to defeat_game_path }
      it { expect(assigns(:game)).to eq game }
    end
  end

  describe '#victory' do
    let!(:grid) do
      grid = FactoryGirl.create(:grid)
      grid.update(victory_box_id: Box.second.id)
      FactoryGirl.create(:npc, current_box_id: Box.second.id)
      grid
    end
    let!(:player) { FactoryGirl.create(:player, current_box_id: Box.first.id) }
    let!(:game) { FactoryGirl.create(:game, grid: grid, player: player) }

    context 'with a signed in user and a beaten game' do
      before do
        player.update(current_box_id: Box.second.id)
        Box.second.npc.stat.update(current_health: 0)
        sign_in user
        get :victory, id: game.id
      end
      it { should respond_with :ok }
      it { should render_template 'victory' }
      it { expect(assigns(:message)).to eq Description.find(game.victory_description_id).text }
      it { expect(assigns(:notes)).to eq [] }
    end
  end

  describe '#defeat' do
    let!(:grid) do
      grid = FactoryGirl.create(:grid)
      grid.update(victory_box_id: Box.second.id)
      FactoryGirl.create(:npc, current_box_id: Box.second.id)
      grid
    end
    let!(:player) { FactoryGirl.create(:player, current_box_id: Box.first.id) }
    let!(:game) { FactoryGirl.create(:game, grid: grid, player: player) }

    context 'with a signed in user and a lost game' do
      before do
        player.stat.update(current_health: 0)
        sign_in user
        get :defeat, id: game.id
      end
      it { should respond_with :ok }
      it { should render_template 'victory' }
      it { expect(assigns(:message)).to eq Description.find(game.defeat_description_id).text }
      it { expect(assigns(:notes)).to eq [] }
    end
  end

  describe '#edit' do
    let!(:grid) { FactoryGirl.create(:grid) }
    let!(:stat) { FactoryGirl.create(:stat, base_attack: 100000) }
    let!(:player) { FactoryGirl.create(:player, stat: stat, current_box_id: grid.find_by_coordinates(1,1).id) }
    let!(:game) { FactoryGirl.create(:game, grid: grid, player: player) }
    let!(:npc) { FactoryGirl.create(:npc, current_box_id: grid.find_by_coordinates(1,1).id) }

    context 'when game_action is a movement action' do
      before do
        npc.delete
        sign_in user
        get :edit, id: game.id, game_action: 'n'
      end
      it { should respond_with :redirect }
      it { should redirect_to game_path(id: Game.first.id) }
      it { expect(assigns(:engine)).to be_instance_of SimpleEngine }
      it 'changes the player\'s current location to be y + 1' do
        expect(Player.first.box.y).to eq 2
      end
    end
    context 'when game_action is an attack action' do
      before do
        sign_in user
        get :edit, id: game.id, game_action: SimpleEngine::COMBAT_ACTIONS[1]
      end
      it { should respond_with :redirect }
      it { should redirect_to game_path(id: Game.first.id) }
      it { expect(assigns(:engine)).to be_instance_of SimpleEngine }
    end
    context 'when action is an unequip action' do
      let!(:item) { FactoryGirl.create(:item, equipped: false) }
      let(:status) { item.equipped? }
      before do
        sign_in user
        #item.update(player: player, current_box_id: nil, equipped: true)
        get :edit, id: game.id, game_action: 'i', item_id: item.id
      end
      it { should respond_with :redirect }
      it { should redirect_to game_path(id: Game.first.id) }
      it { expect(assigns(:engine)).to be_instance_of SimpleEngine }
      #it { expect(item.equipped?).to eq true }
    end
  end
end
