class RegionsController < ApplicationController
  # before_action :authenticate_user!
  before_action :find_area, except: [:create]

  def index
    @regions = policy_scope(Region.all)
  end

  def create
    @region = Region.new region_params
    authorize @region
    @region.save
    p @region.errors.full_messages
    render nothing: true
  end

  def destroy
    authorize @region
    @region.destroy
    render nothing: true
  end

  def update
    authorize @region
    @region.update_attributes(region_params)
    @region.save
    render nothing: true
  end

private

  def region_params
    params.require(:region).permit(:name, :map, {areas_attributes: [:name]})
  end

  def find_area
    @region = Region.find params[:id]
  end

end
