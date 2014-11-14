class AbilitiesController < ApplicationController
  before_action :find_ability, only: [:update]

  # def super_filter

  #   class SuperFilter
  #     attr_accessor :model
  #     def initialize( params )
  #       @model = params[:model]
  #       @options = @model.superfilter

  #     end
  #   end

  # end

  def index
    # @super_filter = SuperFilter.new(model: Ability)
    # @abilities = policy_scope(Ability.includes(:effects, :stat_target, :target, :abil_socket, :jobs).search(params[:keyword]).
    #               ap_cost_search(params[:cost]).effect_search(params[:effect]).
    #               paginate(:page => params[:page], :per_page => 20).name_alphabetical)

    # @filterrific = Filterrific.new(Ability, params[:filterrific])
    # @abilities = Ability.unscoped.filterrific_find(@filterrific).page(params[:page])

    @abilities = Ability.all
    # @abil_socket = AbilSocket.new
    # @abil_sockets = AbilSocket.all
    # @stat_target = StatTarget.new
    # @stat_targets = StatTarget.all
    # @target = Target.new
    # @targets = Target.all
    # @ability_purchase = AbilityPurchase.new
    @ability = Ability.new

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @abilities = Ability.all
    # @abil_socket = AbilSocket.new
    # @abil_sockets = AbilSocket.all
    # @stat_target = StatTarget.new
    # @stat_targets = StatTarget.all
    # @target = Target.new
    # @targets = Target.all
    # @ability_purchase = AbilityPurchase.new
    @ability = Ability.new

    authorize @ability
    @ability = Ability.new ability_params
    respond_to do |format|
      if @ability.save
        format.js { render }
      else
        format.js { render }
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

  # def show
  #   if current_user.admin
  #     respond_to do |format|
  #       format.json { render json: @ability.as_json }
  #     end
  #   end
  # end

  # def edit
  # end

  def update
    # render text: params.to_s

    # @abil_socket = AbilSocket.new
    # @abil_sockets = AbilSocket.all
    # @stat_target = StatTarget.new
    # @stat_targets = StatTarget.all
    # @target = Target.new
    # @targets = Target.all
    # @ability_purchase = AbilityPurchase.new

    authorize @ability
    @ability.update_attributes(ability_params)
    respond_to do |format|
      if @ability.save
        format.js
      else
        format.js
        # alert.now[:error] = "Error read console and refresh page"
        @ability.errors.full_messages.each { |msg| p msg }
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

