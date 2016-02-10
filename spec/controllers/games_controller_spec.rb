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
    let!(:grid) { FactoryGirl.create(:grid) }
    let!(:player) { FactoryGirl.create(:player, current_box_id: Box.first.id) }
    let!(:game) { FactoryGirl.create(:game, grid: grid, player: player) }

    context 'with a signed in user' do
      before do
        sign_in user
        get :show, id: game.id
      end
      it { should respond_with :ok }
      it { should render_template 'show' }
      it { expect(assigns(:game)).to eq game }
      it { expect(assigns(:box)).to eq player.box }
    end
  end

  describe '#edit' do
    let!(:grid) { FactoryGirl.create(:grid) }
    let!(:stat) { FactoryGirl.create(:stat, base_attack: 100000) }
    let!(:player) { FactoryGirl.create(:player, stat: stat, current_box_id: grid.find_by_coordinates(1,1).id) }
    let!(:game) { FactoryGirl.create(:game, grid: grid, player: player) }
    let!(:npc) { FactoryGirl.create(:npc, current_box_id: grid.find_by_coordinates(1,1).id) }

    context 'when game_action is a movement action (n)' do
      before do
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
    context 'when game_action is an attack action (a)' do
      before do
        sign_in user
        get :edit, id: game.id, game_action: 'a'
      end
      it { should respond_with :redirect }
      it { should redirect_to game_path(id: Game.first.id) }
      it { expect(assigns(:engine)).to be_instance_of SimpleEngine }
      it 'changes the player\'s current location to be y + 1' do
        expect(Npc.first.stat.current_health).to eq 0
      end
    end
  end
end
