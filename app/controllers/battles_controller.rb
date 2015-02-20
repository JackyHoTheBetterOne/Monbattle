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

    @recently_unlocked_level = @summoner.recently_unlocked_level
    unlock_message(@summoner)

    respond_to do |format|
      format.html {render :layout => "facebook_landing"}
      format.js
    end
  end

  def create
    if params[:battle]
      create_battle = Battle::Create.new(user: current_user,
                                         summoner: current_user.summoner,
                                         battle_params: battle_params)
    else
      create_battle = Battle::Create.new(user: current_user,
                                         summoner: current_user.summoner)
    end
    create_battle.call
    @battle = create_battle.battle

    if current_user.summoner.stamina >= @battle.battle_level.stamina_cost
      @battle.admin = true if current_user.email == "muffintopper420@mombattle.com"
      @battle.session_id = request.session_options[:id]
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

    if current_user.summoner.beaten_levels.include?(@battle.battle_level.name) && 
        @battle.battle_level.ability_reward.length != 0 && 
        !current_user.summoner.cleared_twice_levels.include?(@battle.battle_level.name)
      @first_cleared = true
    else
      @first_cleared = false
    end

    if current_user.summoner.cleared_twice_levels.include?(@battle.battle_level.name)
      @twice_cleared = true
    else
      @twice_cleared = false
    end

    if @battle.battle_level.name == "First battle" || @battle.battle_level.name == "Area A - Stage 1"
      @show_ap_button = false
    else
      @show_ap_button = true
    end

    if @battle.battle_level.name == "Area A - Stage 1" || @battle.battle_level.name == "Area A - Stage 2" ||
      @battle.battle_level.name == "Area A - Stage 3" || @battle.battle_level.name == "First battle"
      @show_oracle_skill = false
    else
      @show_oracle_skill = true
    end

    if @battle.battle_level.name == "Area A - Stage 4"
      @oracle_skill_turtorial = true
    else
      @oracle_skill_turtorial = false
    end

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
    @battle.is_hacked = false
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
    victory = Battle::Victory.new(summoner: current_user.summoner, 
                                  battle_level: @battle.battle_level,
                                  round_taken: params[:round_taken])

    victory.call

    @victory = victory



    @ability = victory.ability
    @monster = victory.monster
    @reward = victory.reward
    @slot = victory.slot
    @class_list = victory.class_list
    @level_cleared = victory.level_cleared

    @level_up = victory.level_up
    @new_level = victory.new_level
    @stamina_upgrade = victory.stamina_upgrade
    @new_stamina = victory.new_stamina

    @first = victory.first_time
    
    render template: "battles/victory", :layout => false
  end

  def loss  
    if current_user.summoner.played_levels.count == 1
      @first_battle = true
    else
      @first_battle = false
    end

    render template: "battles/defeat", :layout => false
  end

  def tracking_abilities
    @battle.track_ability_frequency(params[:ability_name], current_user.id)
    render nothing: true
  end

  private
  def generate_enemies
    if current_user.summoner.played_levels.count > 0 
      level = BattleLevel.find(battle_params[:battle_level_id])
      Party.generate(level, current_user)
    end
  end

  def unlock_message(summoner)
    if summoner.recently_unlocked_level != ""
      new_level = BattleLevel.find_by_name(summoner.recently_unlocked_level)
      area_name = new_level.area_name
      region_name = new_level.region_name
      flash.now[:success] = "You have unlocked a new level in #{area_name} of #{region_name}!"
      summoner.clear_recent_level
    end

    if summoner.just_achieved_quests != []
      flash.now[:quest] = []
      summoner.just_achieved_quests.each do |q|
        flash.now[:quest].push(q)
      end
      summoner.clear_just_achieved_quests
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
    @battle = Battle.includes(:battle_level).friendly.find(params[:id])
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
    name = User.find_by_user_name(@battle.victor).summoner.name
    if name != "NPC"
      @battle.battle_level.unlock_for_summoner(name, @battle.round_taken, @battle.id) 
    end
  end

  def finish_battle
    @battle.to_finish
  end

  def tracking
    @battle.track_outcome(current_user.id)
    @battle.track_performance(current_user.id)
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









