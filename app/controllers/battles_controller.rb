class BattlesController < ApplicationController
  impressionist :unique => [:controller_name, :action_name, :session_hash]

  before_action :find_battle, except: [:create, :index, :new]
  before_action :check_energy
  after_action :quest_start, only: [:new]

  before_action :generate_enemies, only: :create
  after_action :deduct_energy, only: :create

  after_action :unlock_level_and_ability, only: :update
  after_action :finish_battle, only: :update
  after_action :tracking, only: :update
  before_action :update_general_summoner_fields, only: [:win, :loss]


  def new
    params[:area_filter] ||= session[:area_filter]
    session[:area_filter] = params[:area_filter]

    session[:level_filter] = params[:level_filter]

    new_battle = Battle::New.new(user: current_user, 
                                 params_area_filter: params[:area_filter],
                                 params_level_filter: params[:level_filter],
                                 session_area_filter: session[:area_filter])
    new_battle.call

    @map_url = new_battle.map_url
    @current_region = new_battle.current_region
    @regions = new_battle.regions
    @areas = new_battle.areas
    @latest_level = current_user.summoner.latest_level
    @levels = new_battle.levels
    @battle = new_battle.battle
    @monsters = new_battle.monsters
    @summoner = current_user.summoner if current_user

    unlock_message(@summoner)

    respond_to do |format|
      format.html {render :layout => "facebook_landing"}
      format.js
    end
  end

  def create  
    create_battle = Battle::Create.new(user: current_user,
                                       summoner: current_user.summoner,
                                       battle_params: battle_params)
    create_battle.call
    @battle = create_battle.battle

    if current_user.summoner.stamina >= @battle.battle_level.stamina_cost
      @battle.save
      redirect_to @battle 
    else 
      flash[:warning] = "You don't have enough stamina"
      redirect_to new_battle_path
    end
  end

  def show
    impressionist(@battle)
    @user_party = @battle.parties[0]
    @pc_party   = @battle.parties[1]
    if @battle.impressionist_count <= 2 || current_user.admin
      respond_to do |format|
        format.html { render layout: "facebook_landing" }
        format.json { render json: @battle.build_json  }
      end
    else
      redirect_to new_battle_path
    end
  end

  def update
    @battle.finished = Time.now.in_time_zone("Pacific Time (US & Canada)").to_date
    @battle.outcome = "complete"
    @battle.finished = Time.now.to_date
    @battle.update_attributes(update_params)
    @battle.save
    render nothing: true
  end

  def destroy
    authorize @battle
    if @battle.destroy
      redirect_to battles_path, notice: "Destroyed"
    end
  end

  def showing
    judgement = Battle::Judgement.new(battle: @battle, params: validation_params)
    judgement.call
    render text: judgement.message
  end

  def win
    @ability = Ability.find_by_name(@battle.battle_level.ability_reward[0])
    if current_user
      if current_user.summoner.beaten_levels.include?(@battle.battle_level.name) || params[:round_taken].to_i > @battle.battle_level.time_requirement
        @ability = nil 
      end
    end
    @class_list = ""
    @slot = ""
    array = []
    if @ability != nil
      @ability.ability_restrictions.each do |a|
        if a.job.name.index("NPC") == nil
          array.push(a.job.name)
        end
      end
      @class_list = array.join(", ")
      if @ability.targeta == "attack"
        @slot = "Attack"
      else
        @slot = "Skill"
      end
    end
    render template: "battles/victory", :layout => false
  end

  def loss  
    render template: "battles/defeat", :layout => false
  end

  def tracking_abilities
    @battle.track_ability_frequency(params[:ability_name])
    render nothing: true
  end

  private
  def generate_enemies
    level = BattleLevel.find(battle_params[:battle_level_id])
    Party.generate(level, current_user)
  end

  def unlock_message(summoner)
    if summoner.recently_unlocked_level != ""
      new_level = BattleLevel.find_by_name(summoner.recently_unlocked_level)
      area_name = new_level.area_name
      region_name = new_level.region_name
      flash.now[:success] = "You have unlocked a new level in #{area_name} of #{region_name}!"
      summoner.clear_recent_level
    end
  end

  def change_id
    self.change_code
  end

  def battle_params
    params.require(:battle).permit(:battle_level_id, {party_ids: []})
  end

  def update_params
    params.permit(:victor, :loser, :round_taken, :time_taken)
  end

  def validation_params
    params.permit(:after_action_state, :before_action_state)
  end

  def find_battle
    @battle = Battle.friendly.find params[:id]
    @battle.parties = @battle.parties.order(:npc)
  end

  def quest_start
    if current_user
      @date = Time.now.in_time_zone("Pacific Time (US & Canada)").to_date
      @party = current_user.parties[0]
      if Battle.find_matching_date(@date, @party).count == 0
        @party.user.summoner.quest_begin 
        @party.user.summoner.clear_daily_achievement
        @party.user.summoner.clear_daily_battles
      end
    end
  end

  def check_energy
    if current_user
      @summoner = current_user.summoner
      @summoner.save
    end
  end

  def deduct_energy
    @summoner = current_user.summoner
    if @summoner.stamina >= @battle.battle_level.stamina_cost
      @summoner.stamina -= @battle.battle_level.stamina_cost
      @summoner.save
    end
  end

  def unlock_level_and_ability
    @battle.battle_level.unlock_for_summoner(@battle.victor, @battle.round_taken) 
  end

  def finish_battle
    @battle.to_finish
  end

  def tracking
    @battle.track_outcome
    @battle.track_performance
  end

  def update_general_summoner_fields
    @summoner = current_user.summoner
    
    level_name = @battle.battle_level.name
    level_array = @summoner.played_levels.dup
    level_array.push(level_name) if !level_array.include?(level_name)
    @summoner.played_levels = level_array
    
    id = @battle.id.to_s
    array = @summoner.daily_battles.dup
    array.push(id) if !array.include?(id)
    @summoner.daily_battles = array 

    @summoner.save
  end
end









