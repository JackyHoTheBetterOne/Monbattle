class HomeController < ApplicationController
  layout "facebook_landing", except: [:index]

  def index
    @user      = params[:user] || current_user
    @base_mons = MonsterUnlock.base_mons(@user)
    @abilities = Ability.abilities_purchased(@user)
    @ability_equippings = AbilityEquipping.monster_unlocks(@base_mons)
    @members = @user.parties.first.members
    if @user
    else
      render layout: "facebook_landing"
    end
  end

  def show
  end

  def store
    @ability_purchases =
    @abilities = Ability.all.order(:created_at).limit(4)
    respond_to do |format|
      format.html
      format.json { render json: @abilities }
    end
  end

  def facebook
  end

  def level_select
    render new_battle_path, layout: "facebook_landing"
  end

  def illegal_access
  end

  def roll
    rolling = RollTreasure.new(user: current_user)
    rolling.call
    @treasure = rolling
    @summoner = current_user.summoner
    if rolling.message
      render :json => {
        message: @treasure.message,
        gp: @summoner.gp,
        mp: @summoner.mp
      }
    else
      flash[:alert] = "Something went wrong. It's your fault."
      redirect_to device_store_path
    end
  end

  private

end
