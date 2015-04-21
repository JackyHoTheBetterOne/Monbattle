require 'mandrill'
require 'json'
require 'digest'
require 'uri'
require 'net/http'


class HomeController < ApplicationController
  layout "facebook_landing"
  before_action :find_user, :find_ability_purchases, only: [:index, :abilities_for_mon]
  before_action :check_energy
  before_action :quest_start



#################################################################### Ability equipping
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


############################################################################## Store

  def roll_treasure
    rolling = User::RollTreasure.new(user: current_user, 
                                     roll_type: params[:roll_type], 
                                     currency_type: params[:currency_type])
    rolling.call
    @treasure = rolling
    @summoner = current_user.summoner

    if rolling.message
      current_user.track_rolling(@treasure.rarity, request.session_options[:id], @treasure.type)
      render :json => {
        message: @treasure.message,
        gp: @summoner.gp,
        mp: @summoner.mp,
        type: @treasure.type,
        reward: @treasure.reward_name,
        rarity: @treasure.rarity,
        image: @treasure.image,
        rarity_image: @treasure.rarity_image,
        rarity_color: @treasure.rarity_color,
        first_time: @treasure.first_time,
        desc: @treasure.description,
        job_list: @treasure.job_list,
        modifier: @treasure.modifier,
        impact: @treasure.impact,
        ap_cost: @treasure.ap_cost
      }
    else
      flash[:alert] = "Something went wrong. It's your fault."
      redirect_to device_store_path
    end
  end

  def store
    @abilities = Ability.all.order("created_at DESC").limit(4)
    respond_to do |format|
      format.html
      format.json { render json: @abilities }
    end
  end


########################################################################## Ability learning
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

######################################################################## Monster ascending
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


  def unlock_ascension
    @monster = Monster.find(params[:monster_id])
    if @monster.asp_cost <= current_user.summoner.asp
      @summoner = current_user.summoner
      @summoner.asp -= @monster.asp_cost
      @summoner.save
      MonsterUnlock.create!(user_id: current_user.id, monster_id: params[:monster_id])
    end
    render nothing: true
  end

######################################################################## Monster enhancing
  def enhance_monster
    enhance_monster = params[:enhance_monster] || false
    enhance_id = params[:enhance_id] || false

    enhancement = User::Enhance.new(
      user: current_user,
      selected: enhance_monster,
      enhance_id: enhance_id)

    enhancement.call
    @enhancement = enhancement
  end



######################################################################## The rest

  def forum
    render template: "home/forum"
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
      @notice = @notices.first
    end
  end

  def illegal_access
  end


  def event_levels
    @areas = Area.event_areas

    respond_to do |format|
      format.json {render json: @areas}
    end
  end


  def give_daily_reward
    daily = User::DailyReward.new(summoner: current_user.summoner)
    daily.call
    render :json => {
      type: daily.type,
      amount: daily.reward_amount,
      icon: daily.reward_logo
    }
  end

####################################################################### Tracking
  def track_currency_pick
    session_id = request.session_options[:id]
    current_user.track_currency_pick(session_id, params[:pick])
    render nothing: true
  end

  def track_currency_purchase
    session_id = request.session_options[:id]
    current_user.track_currency_pick(session_id, params[:pick])
    render nothing: true
  end

####################################################################### User update request fields
  def add_request_token
    @user = User.find(current_user.id)
    new_token = params[:request_token]
    old_array = @user.invite_ids.dup
    new_array = old_array.push(new_token)

    @user.invite_ids = new_array
    @user.save
    render nothing: true
  end

  def add_accepted_request
    @user = User.find(current_user.id)
    if @user.request_ids.length == 0 && params[:accepted_invites]
      accepted_request_array = params[:accepted_invites]
      old_array = @user.request_ids.dup
      new_array = old_array.concat(accepted_request_array)

      @user.request_ids = new_array
      @user.save
    end
    render nothing: true
  end

######################################################################### Notification actions
  def notification_action
    notification = Notification.find_by_code(params[:code])
    action = User::NotificationResponse.new(notification: notification, 
                                            decision: params[:decision], 
                                            summoner: current_user.summoner)
    action.call
    render text: action.message
  end


  def notification_sending
    sending = User::NotificationSending.new(type: params[:type],
                                            information_object: params[:information_object],
                                            summoner: current_user.summoner)
    sending.call
    render nothing: true
  end



#########################################################################

  def dick_fly
  end

  # def send_code_email
  #   man = Mandrill::API.new
  #   message = { 
  #     :subject=> "Suck this code", 
  #     :from_name=> "Cock Sucker",
  #     :from_email=>"code_send@cocksuck.com",
  #     :to=> [  
  #       {  
  #        :email=> "fornetflix112@gmail.com",  
  #        :name=> "Jack"  
  #       } 
  #     ], 
  #     :html=> render_to_string('user_mailer/mandrill', :layout => false), 
  #     :merge_vars => [
  #       {
  #         rcpt: "fornetflix112@gmail.com",
  #         vars: [
  #           {name: "first_name", content: "John"},
  #           {name: "last_name", content: "Dicky"}
  #         ]
  #       }
  #     ],
  #     :preserve_recipients => false
  #   }
  #   sending = man.messages.send message 
  #   p sending
  # end

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
      @summoner = current_user.summoner
      if Battle.find_matching_date(@date, @party).count == 0
        if !@summoner.daily_reward_giving_time
          @summoner.daily_reward_given_first = false
          @summoner.daily_reward_given_second = false
          @summoner.daily_reward_giving_time = Time.now + 1.minutes
          @summoner.save
        elsif Time.now.to_date != @summoner.daily_reward_giving_time.to_date
          @summoner.daily_reward_given_first = false
          @summoner.daily_reward_given_second = false
          @summoner.daily_reward_giving_time = Time.now + 1.minutes
          @summoner.save
        end
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
