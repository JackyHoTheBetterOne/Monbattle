class BattlesController < ApplicationController
  before_action :find_battle, except: [:create, :index, :new]
  impressionist :unique => [:controller_name, :action_name, :session_hash]

  def new
    @battle = Battle.new
    @regions = Region.all
    @user = current_user
    Party.generate(@user)
    @summoner = current_user.summoner
    params[:area_filter] ||= session[:area_filter]
    session[:area_filter] = params[:area_filter]

    if params[:area_filter]
      @areas = Area.filter(params[:area_filter])
    elsif session[:area_filter]
      @areas = Area.filter(session[:area_filter])
    else
      @areas = Area.where("name = ?", "")
    end

    if params[:level_filter]
      @levels = BattleLevel.filter(params[:level_filter]).unlocked_levels(@summoner.beaten_levels)
    else
      @levels = BattleLevel.where("name = ?", "")
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
    respond_to do |format|
      format.html {render :layout => "facebook_landing"}
      format.js
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
      @battle.save
      redirect_to @battle
    end
  end

  def show
    impressionist(@battle)
    @user_party = @battle.parties[0]
    @pc_party   = @battle.parties[1]
    if @battle.impressionist_count <= 2 || current_user.admin
      respond_to do |format|
        format.html { render layout: "facebook_landing" if current_user.admin == false }
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

end

