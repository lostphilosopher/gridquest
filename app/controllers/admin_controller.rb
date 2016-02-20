class AdminController < ApplicationController
  before_action :authenticate_admin

  def index
    @users = User.all
    @games = Game.all
  end

  private

  def authenticate_admin
    return redirect_to root_path unless current_user && current_user.admin?
  end
end
