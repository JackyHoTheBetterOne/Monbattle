class AreasController < ApplicationController
  before_action :find_area, except: [:create, :index]

  def index
    @areas = policy_scope(Area.where("start_date IS NOT NULL"))
  end

  def create
    @area = Area.new area_params
    authorize @area
    @area.save
    redirect_to areas_path
  end

  def destroy
    authorize @area
    @area.destroy
    redirect_to areas_path
  end

  def update
    authorize @area
    @area.update_attributes(area_params)
    @area.save
    redirect_to areas_path
  end

private

  def area_params
    params.require(:area).permit(:name, :unlocked_by_id, :order, 
                                 :banner, :start_date, :end_date, :is_guild)
  end

  def find_area
    @area = Area.find params[:id]
  end

end
