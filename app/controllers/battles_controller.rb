class BattlesController < ApplicationController
  before_action :find_battle, except: [:create, :index, :new, :generate_field]

  def index
    @battles = Battle.all
    @fights = Fight.all
  end

  def new
    @battle = Battle.new
    @user = current_user
    respond_to do |format|
      format.html {render :layout => "facebook_landing" if current_user.admin == false}
      format.js
    end
  end

  def create
    # render text: params.to_s
    @battle = Battle.new battle_params
    @user = current_user
    if @battle.save
      @battle.parties.push(Party.find_by_user_id(current_user.id))
      @battle.parties.push(
        Party.where(user: User.find_by_user_name("NPC")).
        where(name: @battle.battle_level.name).
        where(enemy: @user.email).last
        )
      redirect_to @battle, notice: "Battle Starting!"
    else
      render :new
    end
  end

  def show
    @user_party = @battle.parties[0]
    @pc_party   = @battle.parties[1]
    respond_to do |format|
      format.html { render layout: "facebook_landing" if current_user.admin == false }
      format.json { render json: @battle.build_json  }
    end
  end

  def update
    #update victory status at end of battle
  end

  def destroy
    if @battle.destroy
      redirect_to battles_path, notice: "Destroyed"
    end
  end

  def generate_field
    @user = current_user
    Party.generate(@user)
    respond_to do |format|
      format.js
    end
  end

  private

  def battle_params
    params.require(:battle).permit(:outcome, :battle_level_id)
  end

  def find_battle
    @battle = Battle.find params[:id]
    @battle.parties = @battle.parties.order(:npc)
  end

end
