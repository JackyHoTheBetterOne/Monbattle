class BattlesController < ApplicationController
  include Checky
  impressionist :unique => [:controller_name, :action_name, :session_hash]

  before_action :find_battle, except: [:create, :index, :new]
  before_action :check_energy
  after_action :quest_start, only: [:new]
  before_action :daily_reward_reboot, only: [:new]

  before_action :generate_enemies, only: :create
  after_action :deduct_energy, only: :create

  after_action :unlock_level_and_ability, only: :update
  after_action :finish_battle, only: :update
  after_action :tracking, only: :update

  before_action :update_general_summoner_fields, only: [:win, :loss]
  before_action :set_reward_amount, only: [:win]

  def new
    @area_filter = params[:area_filter] || nil
    @level_filter = params[:level_filter] || "dick"


    params[:area_filter] ||= session[:area_filter]
    session[:area_filter] = params[:area_filter]
    session[:level_filter] = params[:level_filter]
    event = params[:event] || false

    new_battle = Battle::New.new(user: current_user, 
                                 params_area_filter: params[:area_filter],
                                 params_level_filter: params[:level_filter],
                                 session_area_filter: session[:area_filter],
                                 event_toggle: event)
    new_battle.call

    @map_url = new_battle.map_url
    @current_region = new_battle.current_region
    @regions = new_battle.regions
    @areas = new_battle.areas
    @latest_level = current_user.summoner.latest_level
    @levels = new_battle.levels
    @battle = new_battle.battle
    @monsters = new_battle.monsters
    @is_event = new_battle.is_event
    @messages = new_battle.messages
    @summoner = current_user.summoner if current_user
    @event_areas = new_battle.event_areas
    @event_count = new_battle.event_areas.count
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

    @show = Battle::Show.new(summoner: current_user.summoner,
                                battle: @battle)
    @show.call

    if @battle.impressionist_count <= 2 || current_user.admin
      respond_to do |format|
        format.html { render layout: "facebook_landing" }
        format.json { render json: @battle.build_json(current_user.parties[0].id) }
      end
    else
      redirect_to new_battle_path
    end
  end

  def update
    @battle.finished = Time.now.in_time_zone("Pacific Time (US & Canada)").to_date
    @battle.is_hacked = false
    @battle.outcome = "complete"
    if session[:reward_num]
      @battle.reward_num = session[:reward_num]
    else 
      @battle.reward_num = 0
    end

    if session[:event_reward_tier]
      @battle.event_reward_tier = session[:event_reward_tier]
    end

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
    @summoner = current_user.summoner
    @summoner.mute = params[:muted]
    @summoner.save

    victory = Battle::Victory.new(summoner: current_user.summoner, 
                                  battle_level: @battle.battle_level,
                                  round_taken: params[:round_taken],
                                  reward_num: session[:reward_num])

    victory.call

    @victory = victory
    session["event_reward_tier"] = @victory.reward_tier
    
    render template: "battles/victory", :layout => false
  end

  def loss  
    @summoner = current_user.summoner
    @summoner.mute = params[:muted]
    @summoner.save
    
    if current_user.summoner.played_levels.count == 1
      @first_battle = true
    else
      @first_battle = false
    end

    render template: "battles/defeat", :layout => false
  end

  def tracking_abilities
    @battle.track_ability_frequency(params[:ability_name], current_user.user_name)
    render nothing: true
  end





  private

  def daily_reward_reboot
    if current_user
      @summoner = current_user.summoner
      @date = Time.now.in_time_zone("Pacific Time (US & Canada)").to_date
      @party = current_user.parties[0]
      if Battle.find_matching_date(@date, @party).count == 0
        if !@summoner.daily_reward_giving_time
          @summoner.daily_reward_given_first = false
          @summoner.daily_reward_given_second = false
          @summoner.daily_reward_giving_time = Time.now + 1.minutes
          @summoner.save
        elsif Time.now.to_date != @summoner.daily_reward_giving_time.to_date
          @summoner.daily_reward_given_first = false
          @summoner.daily_reward_given_second = false
          @summoner.daily_reward_giving_time = Time.now + 1.minutes
          @summoner.save
        end
      end
    end
  end

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
      @summoner = current_user.summoner
      @date = Time.now.in_time_zone("Pacific Time (US & Canada)").to_date
      @party = current_user.parties[0]
      if Battle.find_matching_date(@date, @party).count == 0
        if !@summoner.daily_reward_giving_time
          @summoner.daily_reward_given_first = false
          @summoner.daily_reward_given_second = false
          @summoner.daily_reward_giving_time = Time.now + 1.minutes
          @summoner.save
        elsif Time.now.to_date != @summoner.daily_reward_giving_time.to_date
          @summoner.daily_reward_given_first = false
          @summoner.daily_reward_given_second = false
          @summoner.daily_reward_giving_time = Time.now + 1.minutes
          @summoner.save
        end
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


########################################################################## After battle update

  def set_reward_amount
    @battle_level = @battle.battle_level
    if !@battle_level.event
      if params[:round_taken].to_i >= @battle_level.time_requirement.to_i
        session[:reward_num] = rand(@battle_level.pity_reward[1].to_i..@battle_level.pity_reward[2].to_i) if @battle_level.
          pity_reward.length > 0 
      else
        session[:reward_num] = rand(@battle_level.time_reward[1].to_i..@battle_level.time_reward[2].to_i) if @battle_level.
          time_reward.length > 0
      end
    else
      session[:reward_num] = rand(@battle_level.pity_reward[1].to_i..@battle_level.pity_reward[2].to_i) if @battle_level.
          pity_reward.length > 0 
    end
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

  def unlock_level_and_ability
    summoner = User.find_by_user_name(@battle.victor).summoner
    if summoner.name != "NPC"
      @unlock = Battle::Unlock.new(summoner: summoner, round_taken: @battle.round_taken,
                                    battle: @battle)
      @unlock.call
    end
  end

  def finish_battle
    @battle.to_finish
  end

  def tracking
    @battle.track_outcome(current_user.user_name)
    @battle.track_performance(current_user.user_name)
  end
end









