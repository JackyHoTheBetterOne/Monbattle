class HomeController < ApplicationController
  layout "facebook_landing", except: [:index]

  def index
    @base_mons = MonsterUnlock.base_mons(current_user)
    @abilities = Ability.all
    @ability_equippings = AbilityEquipping.all
    if current_user
      @members = current_user.parties.first.members
    else
      render layout: "facebook_landing"
    end
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
