class HomeController < ApplicationController
  layout "facebook_landing"
  before_action :find_user, :find_ability_purchases, only: [:index, :abilities_for_mon]
  before_action :check_energy

  def index
    @monster_unlocks = @user.monster_unlocks
    @base_mons = @monster_unlocks.base_mons(@user)
    @members = @user.parties.first.members
    @abilities = Ability.includes(:ability_purchases).includes(:abil_socket).
                 includes(:jobs).abilities_purchased(@user).alphabetical
    unless @user
      render layout: "facebook_landing"
    end
  end

  def abilities_for_mon
    @mon = MonsterUnlock.find params[:mon]
    @socket = params[:socket]
    @current_abil_purchase = @mon.abil_purch_in_sock(@socket)
    @abilities = Ability.find_default_abilities_available(@socket, @mon.job).abilities_purchased(@user)
    render :abilities_for_mon
  end

  def store
    @abilities = Ability.all.order("created_at DESC").limit(4)
    respond_to do |format|
      format.html
      format.json { render json: @abilities }
    end
  end

  def facebook
    @notices = Notice.where(is_active: true)
    params[:selected_notice] ||= session[:selected_notice]
    session[:selected_notice] = params[:selected_notice]
    if session[:selected_notice]
      @notice = Notice.find_by_title(params[:selected_notice])
    else
      @notice = @notices[0]
    end
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

  private

  def find_user
    @user = current_user
  end

  def find_ability_purchases
    @ability_purchases = @user.ability_purchases
  end

  def check_energy
    if current_user
      @summoner = current_user.summoner
      @summoner.save
    end
  end

end
