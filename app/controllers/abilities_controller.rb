class AbilitiesController < ApplicationController
  # before_action :authenticate!
  before_action :find_ability, except: [:create]

  def create
    # render text: params.to_s
    @ability = Ability.new ability_params
    if @ability.save
      redirect_to admin_index_path, notice: "Ability Created"
    else
      render :new
    end
  end

  def destroy
    if @ability.destroy
      redirect_to admin_index_path, notice: "Ability Removed"
    else
      redirect_to admin_index_path, notice: "Failure"
    end
  end

  def edit
  end

  def update
    @ability.update_attributes(ability_params)
    if @ability.save
      @ability.ability_equippings.destroy_all
      redirect_to admin_index_path, notice: "Updated"
    else
      render :new
    end

  end

  private

  def find_ability
    @ability = Ability.find params[:id]
  end

  def ability_params
    params.require(:ability).permit(:name, :ap_cost, :store_price, :image_url, :min_level, :price,
      :description, :job_id, :target_id, :stat_target_id, :element_id, :stat_change, {effect_ids: []})
  end
end

