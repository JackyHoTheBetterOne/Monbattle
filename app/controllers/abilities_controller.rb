class AbilitiesController < ApplicationController
  before_action :find_ability, :name_check, only: [:update]
  before_action :find_abilities, except: [:update]

  def index
    @ability = Ability.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
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

