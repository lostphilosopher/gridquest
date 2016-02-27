class DescriptionsController < ApplicationController
  before_action :authenticate_admin

  after_action :add_to_parent, only: [:create]

  def index
  end

  def new
    @parent = params[:parent]
    @parent_id = params[:parent_id]
    @role = params[:role]

    @description = Description.new
  end

  def create
    @parent = params[:description][:parent]
    @parent_id = params[:description][:parent_id]
    @role = params[:description][:role]

    @description = Description.create(description_params)
    redirect_to description_path(@description)
  end

  def show
    @description = Description.find(params[:id])
  end

  private

  def description_params
    params.require(:description).permit(:name, :text)
  end

  def add_to_parent
    case @parent
    when 'Box'
      parent = Box.find(@parent_id)
    when 'Grid'
      parent = Grid.find(@parent_id)
    when 'Item'
      parent = Item.find(@parent_id)
    when 'Npc'
      parent = Npc.find(@parent_id)
    when 'Player'
      parent = Player.find(@parent_id)
    else
      # @todo Handle error...
    end

    case @role
    when 'victory_description'
      parent.update(victory_description_id: @description.id)
    when 'defeat_description'
      parent.update(defeat_description_id: @description.id)
    else
      parent.update(description: @description)
    end
  end
end
