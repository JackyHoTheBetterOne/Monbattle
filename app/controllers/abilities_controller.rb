class AbilitiesController < ApplicationController
  # before_action :authenticate!
  before_action :find_ability, only: [:destroy, :edit]

  def create
    @ability = Ability.new ability_params
    if @ability.save
      redirect_to admin_index_path, notice: "Ability Created"
    else
      redirect_to admin_index_path, notice: "Failed to create"      
    end
  end

  def destroy
    if @ability.destroy
      redirect_to admin_index_path, notice: "Ability Removed"
    else
      redirect_to admin_index_path, notice: "Failure"
    end
  end

  private

  def find_ability
    @ability = Ability.find params[:id]
  end

  def ability_params
    params.require(:ability).permit(:name,:ap_cost, :store_price, :image_url, :min_level, :price, 
      :description, :job_id, {effect_ids: []})
  end

end

