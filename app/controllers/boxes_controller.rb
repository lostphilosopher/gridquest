class BoxesController < ApplicationController
  before_action :authenticate_admin

  def index
  end

  def new
    @box = Box.new
  end

  def create
    @box = Box.create(box_params)
    redirect_to box_path(@box)
  end

  def show
    @box = Box.find(params[:id])
  end

  private

  def box_params
    params.require(:box).permit(:name, :text)
  end
end
