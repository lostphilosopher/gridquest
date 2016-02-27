class GridsController < ApplicationController
  before_action :authenticate_admin

  def index
  end

  def new
    @grid = Grid.new
  end

  def create
    @grid = Grid.create(grid_params)
    redirect_to grid_path(@grid)
  end

  def show
    @grid = Grid.find(params[:id])
  end

  private

  def grid_params
    params.require(:grid).permit(:length, :width)
  end
end
