require 'json'
require 'digest'
require 'uri'
require 'net/http'


class User < ActiveRecord::Base
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
  validates :email, presence: {message: 'Must be entered'}, uniqueness: true

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
                            raw_oauth_info: auth
                           )
      end
    end
  end


  def track_currency_pick(session_id, pick)
    if self.admin == false
      game_key = ENV["GAME_KEY"]
      secret_key = ENV["GAME_SECRET"]
      endpoint_url = "http://api.gameanalytics.com/1"
      category = "design"
      message = {}
      message["event_id"] = "currency_pick:" + pick
      message["user_id"] = self.id
      message["session_id"] = session_id
      message["build"] = "1.00"
      message["value"] = 1.0
      json_message = message.to_json
      json_authorization = Digest::MD5.hexdigest(json_message+secret_key)
      url = "#{endpoint_url}/#{game_key}/#{category}"
      uri = URI(url)
      req = Net::HTTP::Post.new(uri.path)
      req.body = json_message
      req['Authorization'] = json_authorization

      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end

      p "======================================================================="
      p "Currency Pick tracking: #{res.body}"
      p "======================================================================="

    end
  end
  handle_asynchronously :track_currency_pick, :run_at => Proc.new { 2.minutes.from_now }


  def track_currency_purchase(session_id, pick)
    if self.admin == false
      game_key = ENV["GAME_KEY"]
      secret_key = ENV["GAME_SECRET"]
      endpoint_url = "http://api.gameanalytics.com/1"
      category = "design"
      message = {}
      message["event_id"] = "currency_purchase:" + pick
      message["user_id"] = self.id
      message["session_id"] = session_id
      message["build"] = "1.00"
      message["value"] = 1.0
      json_message = message.to_json
      json_authorization = Digest::MD5.hexdigest(json_message+secret_key)
      url = "#{endpoint_url}/#{game_key}/#{category}"
      uri = URI(url)
      req = Net::HTTP::Post.new(uri.path)
      req.body = json_message
      req['Authorization'] = json_authorization

      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end

      p "======================================================================="
      p "Currency Purchase tracking: #{res.body}"
      p "======================================================================="

    end
  end
  handle_asynchronously :track_currency_purchase, :run_at => Proc.new { 2.minutes.from_now }

  def track_rolling(rarity, session_id, type)
    if self.admin == false && rarity != "1" && type != "1"
      game_key = ENV["GAME_KEY"]
      secret_key = ENV["GAME_SECRET"]
      endpoint_url = "http://api.gameanalytics.com/1"
      category = "design"
      message = {}
      message["event_id"] = "rolling_count_user:" + self.user_name
      message["user_id"] = self.id
      message["session_id"] = session_id
      message["build"] = "1.00"
      message["value"] = 1.0
      json_message = message.to_json
      json_authorization = Digest::MD5.hexdigest(json_message+secret_key)
      url = "#{endpoint_url}/#{game_key}/#{category}"
      uri = URI(url)
      req = Net::HTTP::Post.new(uri.path)
      req.body = json_message
      req['Authorization'] = json_authorization

      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end

      p "======================================================================="
      p "Rolling tracking: #{res.body}"
      p "======================================================================="

      message["event_id"] =  "rolling_count_rarity:" + rarity
      message["value"] = 1.0
      json_message = message.to_json
      json_authorization = Digest::MD5.hexdigest(json_message+secret_key)
      req.body = json_message
      req['Authorization'] = json_authorization

      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end

      p "======================================================================="
      p "Rolling tracking: #{res.body}"
      p "======================================================================="

      message["event_id"] =  "rolling_count_type:" + type
      message["value"] = 1.0
      json_message = message.to_json
      json_authorization = Digest::MD5.hexdigest(json_message+secret_key)
      req.body = json_message
      req['Authorization'] = json_authorization

      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end

      p "======================================================================="
      p "Rolling tracking: #{res.body}"
      p "======================================================================="

    end
  end
  handle_asynchronously :track_rolling, :run_at => Proc.new { 2.minutes.from_now }


  def track_login(session_id, time)
    if self.admin == false
      game_key = ENV["GAME_KEY"]
      secret_key = ENV["GAME_SECRET"]
      endpoint_url = "http://api.gameanalytics.com/1"
      category = "design"
      message = {}
      message["event_id"] = "second_batch_user:" + self.user_name
      message["user_id"] = self.id
      message["session_id"] = session_id
      message["build"] = "1.00"
      message["value"] = 1.0
      json_message = message.to_json
      json_authorization = Digest::MD5.hexdigest(json_message+secret_key)
      url = "#{endpoint_url}/#{game_key}/#{category}"
      uri = URI(url)
      req = Net::HTTP::Post.new(uri.path)
      req.body = json_message
      req['Authorization'] = json_authorization

      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end

      p "======================================================================="
      p "Login tracking: #{res.body}"
      p "======================================================================="

      message["event_id"] =  "second_batch_time:" + time
      message["value"] = 1.0
      json_message = message.to_json
      json_authorization = Digest::MD5.hexdigest(json_message+secret_key)
      req.body = json_message
      req['Authorization'] = json_authorization

      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end

      p "======================================================================="
      p "Login tracking: #{res.body}"
      p "======================================================================="

    end
  end
  handle_asynchronously :track_login, :run_at => Proc.new { 2.minutes.from_now }

  private

  def set_namey
    if !self.namey
      self.namey = self.user_name
    end
  end


  def create_summoner
    Summoner.create(user_id: self.id, name: self.namey, vortex_key: 25, gp: 100, mp: 0,
                     completed_daily_quests: [], completed_weekly_quests: [], completed_quests: [])
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
