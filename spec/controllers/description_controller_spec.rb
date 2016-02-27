require 'rails_helper'

RSpec.describe DescriptionController, type: :controller do
  let!(:user) { FactoryGirl.create(:user, email: 'wandersen02@gmail.com') }

  before { sign_in user }

  describe 'GET #index' do
    before { get :index }

    it { expect(response).to have_http_status :ok }
    it { expect(response).to render_template 'index' }
  end

  describe 'GET #new' do
    before { get :new }

    it { expect(response).to have_http_status :ok }
    it { expect(response).to render_template 'new' }
    it { expect(assigns(:grid)).to be_instance_of Description }
  end

  describe 'POST #create' do
    before { post :create, description: { width: 3, length: 3 } }

    it { expect(Description.count).to eq 1 }
  end

  describe 'GET #show' do
    let!(:description) { FactoryGirl.create(:description) }
    before { get :show, { id: description.id } }

    it { expect(response).to have_http_status :ok }
    it { expect(response).to render_template 'show' }
  end
end
