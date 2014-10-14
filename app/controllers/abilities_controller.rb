class AbilitiesController < ApplicationController
  before_action :find_ability, except: [:create, :index]

  def index
    @abilities = Ability.includes(:effects, :stat_target, :target, :abil_socket, :jobs).search(params[:keyword]).
                  ap_cost_search(params[:cost]).paginate(:page => params[:page], :per_page => 10)
    @abil_socket = AbilSocket.new
    @abil_sockets = AbilSocket.all
    @stat_target = StatTarget.new
    @stat_targets = StatTarget.all
    @target = Target.new
    @targets = Target.all
    @ability = Ability.new
    @ability_purchase = AbilityPurchase.new

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    # render text: params.to_s
    @ability = Ability.new ability_params
    authorize @ability
    respond_to do |format|
      if @ability.save
       format.html { redirect_to abilities_path, notice: "Ability Created" }
       format.js { render }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    authorize @ability
    if @ability.destroy
      redirect_to abilities_path, notice: "Ability Removed"
    else
      render :new
    end
  end

  def edit
  end

  def update
    authorize @ability
    @ability.update_attributes(ability_params)
    if @ability.save
      # @ability.ability_equippings.destroy_all #(Temp removed)
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
                             :stat_change, :abil_socket_id, :portrait, {effect_ids: []}, {job_ids: []}
                             )
  end
end

