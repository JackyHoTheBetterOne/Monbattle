class BattlesController < ApplicationController
  before_action :find_battle, except: [:create, :index, :new, :generate_field]
  impressionist :unique => [:controller_name, :action_name, :session_hash]

  def new
    @battle = Battle.new
    @user = current_user
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
    @battle.save
    render nothing: true
  end

  def destroy
    authorize @battle
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

  def validation

  end

  private

  def battle_params
    params.require(:battle).permit(:battle_level_id, {party_ids: []})
  end

  def update_params
    params.permit(:victor, :loser, :round_taken)
  end

  def find_battle
    @battle = Battle.friendly.find params[:id]
    @battle.parties = @battle.parties.order(:npc)
  end

end

