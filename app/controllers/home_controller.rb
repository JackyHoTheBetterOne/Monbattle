class HomeController < ApplicationController
  layout "facebook_landing"

  def index
    @user      = params[:user] || current_user
    @base_mons = MonsterUnlock.base_mons(@user)
    @abilities = Ability.includes(:ability_purchases).includes(:abil_socket).includes(:jobs).abilities_purchased(@user)
    @ability_purchases = @user.ability_purchases
    @members = @user.parties.first.members
    if !@user
      render layout: "facebook_landing"
    end
  end

  def store
    @abilities = Ability.all.order("created_at DESC").limit(4)
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

  def roll_trash
    rolling = User::RollTrash.new(user: current_user)
    rolling.call
    @trash = rolling
    @summoner = current_user.summoner
    if rolling.message
      render :json => {
        message: @trash.message,
        mp: @summoner.mp
      }
    else
      flash[:alert] = "Something went wrong. It's your fault."
      redirect_to device_store_path
    end
  end

  def roll_treasure
    rolling = User::RollTreasure.new(user: current_user)
    rolling.call
    @treasure = rolling
    @summoner = current_user.summoner
    if rolling.message
      render :json => {
        message: @treasure.message,
        gp: @summoner.gp
      }
    else
      flash[:alert] = "Something went wrong. It's your fault."
      redirect_to device_store_path
    end
  end
end
