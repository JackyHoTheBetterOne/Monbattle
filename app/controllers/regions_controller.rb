class RegionsController < ApplicationController
  # before_action :authenticate_user!
  before_action :find_area, except: [:index, :create]

  def index
    @areas = policy_scope(Area.all)
    @regions = policy_scope(Region.search(params[:keyword]))
    @region = Region.new
  end

  def create
    @region = Region.new region_params
    authorize @region
    @region.save
  end

  def destroy
    authorize @region
    @region.destroy
  end

  def update
    authorize @region
    @region.update_attributes(region_params)
    @region.save
  end

private

  def region_params
    params.require(:region).permit(:id, :name, :map, {areas_attributes: [:id, :name, :_destroy]})
  end

  def find_area
    @region = Region.find params[:id]
  end

end
