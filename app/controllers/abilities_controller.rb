class AbilitiesController < ApplicationController
  before_action :find_ability, :name_check, only: [:update]
  before_action :find_abilities, except: [:update]

  def index
    # @abilities = policy_scope(Ability.includes(:effects, :stat_target, :target, :abil_socket, :jobs).search(params[:keyword]).
    #               ap_cost_search(params[:cost]).effect_search(params[:effect]).
    #               paginate(:page => params[:page], :per_page => 20).name_alphabetical)

    # @abil_socket = AbilSocket.new
    # @abil_sockets = AbilSocket.all
    # @stat_target = StatTarget.new
    # @stat_targets = StatTarget.all
    # @target = Target.new
    # @targets = Target.all
    # @ability_purchase = AbilityPurchase.new

    # render text: params.to_s

    @ability = Ability.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    # @abil_socket = AbilSocket.new
    # @abil_sockets = AbilSocket.all
    # @stat_target = StatTarget.new
    # @stat_targets = StatTarget.all
    # @target = Target.new
    # @targets = Target.all
    # @ability_purchase = AbilityPurchase.new
    @ability = Ability.new ability_params
    authorize @ability
    respond_to do |format|
      if @ability.save
        format.js
      else
        format.js
        format.html { redirect_to abilities_path }
      end
    end
  end

  def update
    # render text: params.to_s

    # @abil_socket = AbilSocket.new
    # @abil_sockets = AbilSocket.all
    # @stat_target = StatTarget.new
    # @stat_targets = StatTarget.all
    # @target = Target.new
    # @targets = Target.all
    # @ability_purchase = AbilityPurchase.new
    @user = current_user
    authorize @ability
    @ability.update_attributes(ability_params)
    respond_to do |format|
      if @ability.save
        format.js
      else
        format.js
        @ability.errors.full_messages.each { |msg| p msg }
      end
    end
  end

  private

  def find_ability
    @ability = Ability.find params[:id]
  end

  def name_check
    if ["Slap", "Groin Kick", "Omega Slash", "Discharge"].include? @ability.name
      params[:ability][:name] = @ability.name
    end
  end

  def find_abilities
    if params[:filter]
      @abilities = Ability.unscoped.filter_it(params[:filter]).includes(:effects, :stat_target, :target, :abil_socket, :jobs, :rarity)
    else
      @abilities = Ability.reorder("lower(name)").includes(:effects, :stat_target, :target, :abil_socket, :jobs, :rarity)
    end
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

