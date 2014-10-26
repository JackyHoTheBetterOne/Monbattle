class HomeController < ApplicationController
  layout "facebook_landing", except: [:index]

  def index
    @base_mons = MonsterUnlock.base_mons(current_user)
    @abilities = Ability.all
    @ability_equippings = AbilityEquipping.all
    @members = current_user.parties.first.members
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
    if rolling.message
      render text: rolling.message
    else
      flash[:alert] = "Something went wrong. It's your fault."
      redirect_to device_store_path
    end
  end

  private

end
