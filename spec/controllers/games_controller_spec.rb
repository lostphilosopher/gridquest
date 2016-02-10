require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe '#index' do
    context '' do
      before do
        get :index
      end
      it { should respond_with :ok }
      it { should render_template 'index' }
    end
  end

  describe '#new' do
    let!(:user) { FactoryGirl.create(:user) }
    context '' do
      before do
        sign_in user
        post :new
      end
      it { should respond_with :ok }
      it { should redirect_to game_path }
    end
  end
end
