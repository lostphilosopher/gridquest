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
    v = Description.create(
      name: params[:victory_description][:name],
      text: params[:victory_description][:text],
    )
    d = Description.create(
      name: params[:defeat_description][:name],
      text: params[:defeat_description][:text],
    )

    {
      length: params[:grid][:length],
      width: params[:grid][:width],
      victory_description_id: v.id,
      defeat_description_id: d.id

    }
  end
end
