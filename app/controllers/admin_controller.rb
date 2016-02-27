class AdminController < ApplicationController
  before_action :authenticate_admin

  def index
    @users = User.all
    @games = Game.all
  end
end
