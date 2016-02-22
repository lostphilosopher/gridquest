require 'rails_helper'

RSpec.describe AdminController, type: :controller do
  let!(:user) { FactoryGirl.create(:user, email: 'wandersen02@gmail.com') }

  describe '#index' do
    context 'without a signed in user' do
      before do
        get :index
      end
      it { should respond_with :redirect }
      it { should redirect_to root_path }
    end
    context 'with a signed in user' do
      before do
        sign_in user
        get :index
      end
      it { should respond_with :ok }
      it { should render_template 'index' }
    end
  end
end
