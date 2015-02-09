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

    if current_user.user_name == "admin"
      @abilities = Ability.find_default_abilities_available(@socket, @mon.job).abilities_purchased(@user)
    else
      @abilities = @mon.learned_ability_array_with_socket(@socket)
      # @abilities = @mon.learned_ability_array
    end
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
      current_user.track_rolling(@treasure.rarity, request.session_options[:id])
      render :json => {
        message: @treasure.message,
        gp: @summoner.gp,
        type: @treasure.type,
        reward: @treasure.reward_name,
        rarity: @treasure.rarity,
        image: @treasure.image,
        rarity_image: @treasure.rarity_image,
        rarity_color: @treasure.rarity_color
      }
    else
      flash[:alert] = "Something went wrong. It's your fault."
      redirect_to device_store_path
    end
  end

  def forum
    render template: "home/forum"
  end

  def learn_ability
    user_id = current_user.id
    @unlearned_abilities = AbilityPurchase.order(:created_at).not_learned(user_id).
                           search(params[:keyword]).limit(50)
    if params[:keyword]
      @search = true
    else
      @search = false
    end

    if params[:learning_filter]
      @monster_students = []

      @ability = AbilityPurchase.find_by_id_code(params[:learning_filter]).ability
      @students = MonsterUnlock.learning_filter(user_id, params[:learning_filter])

      @students.each do |s|
        if !s.learned_ability_array.include?(@ability)
          @monster_students << s
        end
      end
    else 
      @monster_students = "initial"
    end
  end

  def ascend_monster
    if params[:ascend_monster]
      ascend = User::Ascend.new(user: current_user, 
                                selected_ascension: params[:ascend_monster])
    else 
      ascend = User::Ascend.new(user: current_user)
    end
    ascend.call
    @ascension = ascend




  end



  private

  def find_user
    @user = current_user
  end

  def generate_enemies
    Party.generate(current_user)
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
