class AbilitiesController < ApplicationController
  before_action :find_ability, except: [:create, :index]

  def index
    @abilities = policy_scope(Ability.includes(:effects, :stat_target, :target, :abil_socket, :jobs).search(params[:keyword]).
                  ap_cost_search(params[:cost]).effect_search(params[:effect]).
                  paginate(:page => params[:page], :per_page => 20).name_alphabetical)
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

  # def destroy
  #   authorize @ability
  #   if @ability.destroy
  #     redirect_to abilities_path, notice: "Ability Removed"
  #   else
  #     render :new
  #   end
  # end

  def show 
    if current_user.admin
      respond_to do |format| 
        format.json { render json: @ability.as_json }
      end
    end
  end

  def edit
  end

  def update
    authorize @ability
    @ability.update_attributes(ability_params)
    respond_to do |format|
      if @ability.save
        # @ability.ability_equippings.destroy_all #(Temp removed)
        format.js
      else
        format.js
        render :new
      end
    end
  end

  private

  def find_ability
    @ability = Ability.find params[:id]
  end

  def ability_params
    params.require(:ability).permit(
                             :name, :ap_cost, :image, :min_level, :mp_cost, :gp_cost, :rarity_id,
                             :description, :job_id, :target_id, :stat_target_id, :element_id,
                             :stat_change, :abil_socket_id, :portrait, :former_name,
                             {effect_ids: []}, {job_ids: []}
                             )
  end
end

