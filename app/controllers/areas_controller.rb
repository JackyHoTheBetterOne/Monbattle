class AreasController < ApplicationController
  before_action :find_area, except: [:create, :index]

  def create
    @area = Area.new area_params
    authorize @area
    @area.save
    render nothing: true
  end

  def destroy
    authorize @area
    @area.destroy
    render nothing: true
  end

  def update
    authorize @area
    @area.update_attributes(area_params)
    @area.save
    render nothing: true
  end

private

  def area_params
    params.require(:area).permit(:name, {battle_levels: []})
  end

  def find_area
    @area = Area.find params[:id]
  end

end
