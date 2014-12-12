class BattlesController < ApplicationController
  before_action :find_battle, except: [:create, :index, :new]
  impressionist :unique => [:controller_name, :action_name, :session_hash]
  before_action :check_energy
  before_action :quest_start, only: :new
  after_action :deduct_energy, only: :create

  def new
    @battle = Battle.new
    @user = current_user
    Party.generate(@user)
    @summoner = current_user.summoner
    @regions = Region.all.unlocked_regions(@summoner.completed_regions)
    
    params[:area_filter] ||= session[:area_filter]
    session[:area_filter] = params[:area_filter]

    if session[:area_filter]
      @map_url = Region.find_by_name(session[:area_filter]).map.url(:cool)
    else
      @map_url = @regions.last.map.url(:cool)
    end

    if params[:area_filter]
      @areas = Area.filter(params[:area_filter]).unlocked_areas(@summoner.completed_areas)
    elsif session[:area_filter]
      @areas = Area.filter(session[:area_filter]).unlocked_areas(@summoner.completed_areas)
    else
      @areas = Area.where("name = ?", "")
    end

    if params[:level_filter]
      @levels = BattleLevel.order("id").filter(params[:level_filter]).unlocked_levels(@summoner.beaten_levels)
    else
      @levels = BattleLevel.order("id").where("name = ?", "")
    end

    if @summoner.recently_unlocked_level != nil
      new_level = BattleLevel.find_by_name(@summoner.recently_unlocked_level)
      area_name = new_level.area_name
      region_name = new_level.region_name
      flash.now[:success] = "You have unlocked a new level in #{area_name} of #{region_name}!"
      @summoner.clear_recent_level
    end

    if current_user
      @monsters = @user.parties.first.monster_unlocks
    end
    if current_user
      respond_to do |format|
        format.html {render :layout => "facebook_landing"}
        format.js
      end
    end
  end

  def create
    if current_user.parties[0].battles.count == 0
      @battle = Battle.new 
      @battle.battle_level_id = 1000000000000000000000
      @battle.parties.push(Party.where(name: "ur sister dead")[0])
      @battle.parties.push(Party.where(name: "me raping ur sister")[0])
      @battle.save
      redirect_to @battle
    else
      @battle = Battle.new battle_params
      @user = current_user
      @battle.parties.push(Party.find_by_user_id(current_user.id))
      @battle.parties.push(
        Party.where(user: User.find_by_user_name("NPC")).
        where(name: @battle.battle_level.name).
        where(enemy: @user.user_name).last
        )
      if current_user.summoner.stamina >= @battle.battle_level.stamina_cost
        @battle.save
        redirect_to @battle 
      else 
        flash[:warning] = "You don't have enough stamina"
        redirect_to new_battle_path
      end
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
      flash[:alert] = "You need to fuck off!"
      redirect_to new_battle_path
    end
  end

  def update
    @battle.outcome = "complete"
    @battle.update_attributes(update_params)
    @battle.to_finish
    @battle.save
    render nothing: true
  end

  def destroy
    authorize @battle
    if @battle.destroy
      redirect_to battles_path, notice: "Destroyed"
    end
  end

  def validation
    validation = Battle::Validation.new(battle: @battle, params: validation_params)
    validation.call
    render text: validation.message
  end

  def judgement
    judgement = Battle::Judgement.new(battle: @battle, params: validation_params)
    judgement.call
    render text: judgement.message
  end

  private

  def battle_params
    params.require(:battle).permit(:battle_level_id, {party_ids: []})
  end

  def update_params
    params.permit(:victor, :loser, :round_taken)
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
      @date = Time.now.localtime.to_date
      @party = current_user.parties[0]
      p "================================================================================="
      p Time.now.localtime.to_date
      p Battle.find_matching_date(@date, @party).count
      p "================================================================================="
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
end

