class AbilitiesController < ApplicationController
  # before_action :authenticate!
  before_action :find_ability, only: [:destroy]

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
    @ability = ability.find params[:id]
  end

  def ability_params
    params.require(:ability).permit(
    :class_template_id, :name, :ap_cost, :description, :min_level, :power_level, :store_price, :type, :image_url, :price, {effect_ids: []})
  end

end

