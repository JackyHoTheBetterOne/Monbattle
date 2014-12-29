class HomeController < ApplicationController
  layout "facebook_landing"
  before_action :find_user, :find_ability_purchases, only: [:index, :abilities_for_mon]
  before_action :check_energy
  before_action :quest_start

  def index
    @monster_unlocks = @user.monster_unlocks
    @base_mons = @monster_unlocks.base_mons(@user)
    @monster_list = @base_mons
    @members = @user.parties.first.members
    @abilities = Ability.includes(:ability_purchases).includes(:abil_socket).
                 includes(:jobs).abilities_purchased(@user).alphabetical
    unless @user
      render layout: "facebook_landing"
    end
  end

  def equip_filter
    @monster_list = current_user.monster_unlocks.search(params[:keyword])
                             .base_mons(current_user)
    respond_to do |format|
      format.js
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
    @notices = Notice.order("created_at DESC").where(is_active: true)
    params[:selected_notice] ||= session[:selected_notice]
    session[:selected_notice] = params[:selected_notice]
    if Notice.find_by_title(params[:selected_notice])
      @notice = Notice.find_by_title(params[:selected_notice])
    elsif @notices.count == 0
      @notice = nil
    else 
      @notice = @notices.last
    end
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

  def forum
    render template: "home/forum"
  end


  private

  def find_user
    @user = current_user
  end


  def quest_start
    if current_user
      @date = Time.now.in_time_zone("Pacific Time (US & Canada)").to_date
      @party = current_user.parties[0]
      if Battle.find_matching_date(@date, @party).count == 0
        @party.user.summoner.quest_begin 
        @party.user.summoner.clear_daily_achievement
        @party.user.summoner.clear_daily_battles
      end
    end
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
