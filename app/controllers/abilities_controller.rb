class AbilitiesController < ApplicationController
  before_action :find_ability, except: [:create, :index]

  def index
    @abil_socket = AbilSocket.new
    @abil_sockets = AbilSocket.all
    @stat_target = StatTarget.new
    @stat_targets = StatTarget.all
    @target = Target.new
    @targets = Target.all
    @ability = Ability.new
    @abilities = Ability.all
    @ability_purchase = AbilityPurchase.new
  end

  def create
    # render text: params.to_s
    @ability = Ability.new ability_params
    respond_to do |format|
      if @ability.save
       format.html { redirect_to abilities_path, notice: "Ability Created" }
       format.js { render }
      else
        render :new
      end
    end
  end

  def destroy
    if @ability.destroy
      redirect_to abilities_path, notice: "Ability Removed"
    else
      redirect_to abilities_path, notice: "Failure"
    end
  end

  def edit
  end

  def update
    @ability.update_attributes(ability_params)
    if @ability.save
      @ability.ability_equippings.destroy_all
      redirect_to abilities_path, notice: "Updated"
    else
      render :new
    end
  end

  private

  def find_ability
    @ability = Ability.find params[:id]
  end

  def ability_params
    params.require(:ability).permit(
                             :name, :ap_cost, :store_price, :image, :min_level, :price,
                             :description, :job_id, :target_id, :stat_target_id, :element_id,
                             :stat_change, :abil_socket_id, {effect_ids: []}, {job_ids: []}
                             )
  end
end

