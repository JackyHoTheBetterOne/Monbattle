class RegionsController < ApplicationController
  # before_action :authenticate_user!
  before_action :find_area, except: [:index, :create]

  def index
    @areas = Area.all
    @regions = Region.all
    @region = Region.new
  end

  def create
    @region = Region.new region_params
    authorize @region
    @region.save
    p @region.errors.full_messages
    redirect_to regions_path
  end

  def destroy
    authorize @region
    @region.destroy
    redirect_to regions_path
  end

  def update
    authorize @region
    @region.update_attributes(region_params)
    @region.save
    redirect_to regions_path
  end

private

  def region_params
    params.require(:region).permit(:id, :name, :map, {areas_attributes: [:id, :name, :_destroy]})
  end

  def find_area
    @region = Region.find params[:id]
  end

end
