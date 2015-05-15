require 'json'
require 'digest'
require 'uri'
require 'net/http'


class User < ActiveRecord::Base
  # User.select{|u| u.invite_ids.include?("111")}
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # validates :password, presence: {message: 'Must be entered'}

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  has_one :summoner, dependent: :destroy
  has_many :parties, dependent: :destroy
  has_many :members, through: :parties

  serialize :raw_oauth_info

  has_many :monster_skin_equippings, dependent: :destroy

  has_many :monster_unlocks, dependent: :destroy
  has_many :monsters, through: :monster_unlocks

  has_many :monster_skin_purchases, dependent: :destroy
  has_many :ability_purchases, dependent: :destroy
  has_many :abilities, through: :ability_purchases, source: :ability

  validates :user_name, presence: {message: 'Must be entered'}, uniqueness: true

  after_create :create_summoner
  after_create :create_party
  after_create :unlock_default_monsters
  before_create :set_namey

  scope :rarity_filter, -> (rarity) {
    if rarity == "npc"
      self.where(user_name: "NPC")
    else
      self.all
    end
  }

  def self.method_missing(method_name, *args)
    methods_allowed = [:responsible_find_by_kon_id, :responsible_find_by_user_name]
    if methods_allowed.include?(method_name)
      self.class.class_eval do 
        define_method(method_name) do |a|
          name_string = method_name.to_s
          method = "find_by_" + name_string.gsub("responsible_find_by_", "")
          begin
            self.send(method.to_sym, a)
          rescue
            nil
          end
        end
      end
      self.send(method_name, *args)
    else
      super
    end
  end



############################################################################################################# Decoration

  def battle_count
    self.summoner.played_levels.count + self.summoner.cleared_twice_levels.count
  end

  def first_time_replay(battle_level_name)
    @summoner = self.summoner
    if @summoner.played_levels.include?(battle_level_name) && @summoner.
        cleared_twice_levels.count == 0 
      return true
    else
      return false
    end
  end


  def can_add_to_party?(mon_unlock)
    if self.members.count == 0 || self.members.count < 4 && self.members.where(monster_unlock_id: mon_unlock).empty?
      return true
    else
      return false
    end
  end

  def can_remove_from_party?(mon_unlock)
    if self.members.count >= 1 && self.members.where(monster_unlock_id: mon_unlock).exists?
      return true
    else
      return false
    end
  end


################################################################################################################

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create!(user_name: auth.extra.raw_info.name + "." + Random.new.rand(0..10000).to_s,
                            first_name: auth.extra.raw_info.first_name,
                            namey: auth.extra.raw_info.name, 
                            provider: auth.provider,
                            uid: auth.uid,
                            email: auth.info.email,
                            image: auth.info.image,
                            password: Devise.friendly_token[0,20],
                            raw_oauth_info: auth,
                            avatar: auth.extra.raw_info.image,
                           )
      end
    end
  end


################################################################################################# User tracking

  def track_currency_pick(session_id, pick)
    if self.admin == false
      event_id = "currency_pick:" + pick
      tracking = User::Tracking.new(user: self, session_id: session_id, 
                                      event_id: event_id, value: 1)
      tracking.user_side_tracking
      tracking.call
    end
  end
  handle_asynchronously :track_currency_pick


  def track_currency_purchase(session_id, pick)
    if self.admin == false
      event_id = "currency_purchase:" + pick
      tracking = User::Tracking.new(user: self, session_id: session_id, 
                                      event_id: event_id, value: 1)
      tracking.user_side_tracking
      tracking.call
    end
  end
  handle_asynchronously :track_currency_purchase

  def track_rolling(rarity, session_id, type)
    if self.admin == false && rarity != "1" && type != "1"
      event_id_1 = "rolling_count_user:" + self.user_name
      roll_tracking = User::Tracking.new(user: self, session_id: session_id, 
                                      event_id: event_id_1, value: 1)
      roll_tracking.user_side_tracking
      roll_tracking.call

      event_id_2 = "rolling_count_rarity:" + rarity
      rarity_tracking = User::Tracking.new(user: self, session_id: session_id, 
                                      event_id: event_id_2, value: 1)
      rarity_tracking.user_side_tracking
      rarity_tracking.call

      event_id_3 = "rolling_count_type:" + type
      rolling_type_tracking = User::Tracking.new(user: self, session_id: session_id, 
                                      event_id: event_id_3, value: 1)
      rolling_type_tracking.user_side_tracking
      rolling_type_tracking.call
    end
  end
  handle_asynchronously :track_rolling


  def track_login(session_id, time)
    if self.admin == false
      event_id_1 = "second_batch_user:" + self.user_name
      login_tracking = User::Tracking.new(user: self, session_id: session_id, 
                                      event_id: event_id_1, value: 1)
      login_tracking.user_side_tracking
      login_time_tracking.call

      event_id_2 = "second_batch_time:" + time
      login_time_tracking = User::Tracking.new(user: self, session_id: session_id, 
                                      event_id: event_id_2, value: 1)
      login_time_tracking.user_side_tracking
      login_time_tracking.call
    end
  end
  handle_asynchronously :track_login

###############################################################################################################

  private

  def set_namey
    if !self.namey
      self.namey = self.user_name
    end
  end


  def create_summoner
    Summoner.create(user_id: self.id, name: self.namey, vortex_key: 25, gp: 100, mp: 0,
                     completed_daily_quests: [], completed_weekly_quests: [], completed_quests: [],
                     daily_reward_giving_time: Time.now + 5.minutes + 30.seconds, facebook_id: self.uid)
  end

  def create_party
    Party.create(name: "Your Party", user_id: self.id)
  end

  def unlock_default_monsters
    unless Monster.all.empty?
      @default_monster_ids = Monster.find_default_monster_ids
      @user_id = self.id

      @default_monster_ids.each do |id|
        MonsterUnlock.create(user_id: @user_id, monster_id: id)
      end
    end
    self.monster_unlocks.each do |m|
      self.parties[0].monster_unlocks << m
    end
  end

end
