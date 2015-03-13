require 'aasm'
require 'json'
require 'digest'
require 'uri'
require 'net/http'


class Battle < ActiveRecord::Base
  is_impressionable
  include AASM
  extend FriendlyId
  friendly_id :id_code
  belongs_to :battle_level
  has_many :fights, dependent: :destroy
  has_many :parties, through: :fights

  validates :battle_level_id, presence: {message: 'Must be entered'}
  before_create :generate_code
  before_destroy :destroy_impressions

  scope :find_matching_date, -> (date, party) {
    joins(:fights).where(finished: date, "fights.party_id" => party.id)
  }

  aasm do
    state :battling, :initial => true
    state :hacked
    state :complete, :before_enter => :victor_check, :after_enter => :distribute_quest_reward

    event :done do
      transitions :from => :battling, :to => :complete
    end

    event :ruined do 
      transitions :from => :battling, :to => :hacked
    end
  end

  def self.average_round(level_id)
    average(:round_taken).where("battle_level_id = #{level_id}")
  end

  def self.average_time(level_id)
    average(:time_taken).where("battle_level_id = #{level_id}")
  end

  def background
    self.battle_level.background
  end

  def start_cutscene
    if !self.battle_level.start_cutscene.blank?
      self.battle_level.start_cutscene.url(:cool)
    else
      "none"
    end
  end

  def end_cutscene
    if !self.battle_level.end_cutscene.blank?
      self.battle_level.end_cutscene.url(:cool)
    else
      "none"
    end
  end

  def level_name
    self.battle_level.name
  end

############################################################################################### End Battle Update
  def to_finish
    if self.aasm_state == "battling" && self.is_hacked == false
      self.done
      self.save
    elsif self.is_hacked == true
      self.ruined
      self.save
    end
  end

  def victor_check
    if self.victor == "NPC"
      @loser = Summoner.find_summoner(self.loser)
      @loser.check_quest
    else
      self.give_reward
    end
  end

  def give_reward
    @battle_level        = self.battle_level
    @exp_reward          = self.battle_level.exp_given
    @victorious_summoner = Summoner.find_summoner(self.victor)
    @victorious_summoner.wins += 1 

    if @victorious_summoner.exp_required <= @exp_reward + @victorious_summoner.current_exp
      @victorious_summoner.current_exp = @exp_reward + @victorious_summoner.current_exp - 
        @victorious_summoner.exp_required 
      @level = SummonerLevel.find_by_level(@victorious_summoner.level+1)
      @victorious_summoner.summoner_level = @level
      @victorious_summoner.stamina = @level.stamina
    else
      @victorious_summoner.current_exp += @exp_reward
    end

    if @victorious_summoner.beaten_levels.include?(@battle_level.name) 
      if self.round_taken < @battle_level.time_requirement && @battle_level.time_reward.length != 0
        @victorious_summoner[@battle_level.time_reward[0]] += self.reward_num
      elsif self.round_taken >= @battle_level.time_requirement && @battle_level.pity_reward.length != 0
        @victorious_summoner[@battle_level.pity_reward[0]] += self.reward_num
      end
    end

    @victorious_summoner.save
    @victorious_summoner.check_quest
  end

  def distribute_quest_reward
    @victor = Summoner.find_summoner(self.victor)
    @loser = Summoner.find_summoner(self.loser)
    @victor.get_achievement
    @victor.get_login_bonus_for_wins
    @loser.get_achievement
    @victor.save
    @loser.save
  end



############################################################################################## General methods

  def build_json
    battle_json = {}
    battle_json[:summoner_abilities] = Ability.joins(:rarity).where("rarities.name = 'oracle'").map(&:as_json)
    battle_json[:level_name] = self.battle_level.name
    battle_json[:code] = self.parties[0].user.summoner.code
    battle_json[:background] = self.background
    battle_json[:start_cut_scenes] = self.battle_level.start_cut_scenes
    battle_json[:end_cut_scenes] = self.battle_level.end_cut_scenes
    battle_json[:defeat_cut_scenes] = self.battle_level.defeat_cut_scenes
    battle_json[:id] = self.id_code
    battle_json[:players] = []

    self.parties.order(:npc).each do |party|
      battle_json[:players] << party.as_json
    end

    return battle_json
  end

  def generate_code
    self.id_code = SecureRandom.uuid
  end

  def destroy_impressions
    self.impressions.destroy_all
  end

####################################################################################### End battle tracking

  def track_outcome(user_id)
    if self.admin == false
      game_key = ENV["GAME_KEY"]
      secret_key = ENV["GAME_SECRET"]
      endpoint_url = "http://api.gameanalytics.com/1"
      category = "design"
      message = {}
      if self.victor == "NPC"
        message["event_id"] = "outcome:defeat"
      else
        message["event_id"] = "outcome:victory"
      end
      message["user_id"] = user_id
      message["area"] = self.battle_level.name.gsub(" ", "_")
      message["session_id"] = self.session_id
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
      p "Outcome tracking: #{res.body}"
      p "======================================================================="
    end
  end
  handle_asynchronously :track_outcome



  def track_progress(user_id)
    if self.admin == false
      game_key = ENV["GAME_KEY"]
      secret_key = ENV["GAME_SECRET"]
      endpoint_url = "http://api.gameanalytics.com/1"
      category = "design"
      message = {}
      message["event_id"] = "level_unlock" + ":" + self.battle_level.name.gsub(" ", "_")
      message["user_id"] = user_id
      message["session_id"] = self.session_id
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
      p "Outcome tracking: #{res.body}"
      p "======================================================================="

      user_name = User.find(user_id).user_name
      message["event_id"] =  "level_unlock" + ":" + user_name
      message["value"] = 1
      json_message = message.to_json
      json_authorization = Digest::MD5.hexdigest(json_message+secret_key)
      req.body = json_message
      req['Authorization'] = json_authorization

      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end

      p "======================================================================="
      p "Outcome tracking: #{res.body}"
      p "======================================================================="
    end
  end
  handle_asynchronously :track_progress



  def track_performance(user_id)
    if self.admin == false
      game_key = ENV["GAME_KEY"]
      secret_key = ENV["GAME_SECRET"]
      endpoint_url = "http://api.gameanalytics.com/1"
      category = "design"
      message = {}
      message["area"] = self.battle_level.name.gsub(" ", "_") 
      message["event_id"] = "time_taken"
      message["user_id"] = user_id
      message["session_id"] = self.session_id
      message["build"] = "1.00"
      message["value"] = self.time_taken
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
      p "Performance tracking: #{res.body}"
      p "======================================================================="

      message["event_id"] = "turns_taken"
      message["value"] = self.round_taken
      json_message = message.to_json
      json_authorization = Digest::MD5.hexdigest(json_message+secret_key)
      req.body = json_message
      req['Authorization'] = json_authorization

      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end

      p "======================================================================="
      p "Performance tracking: #{res.body}"
      p "======================================================================="

      message["event_id"] =  "battle_finish_count"
      message["value"] = 1
      json_message = message.to_json
      json_authorization = Digest::MD5.hexdigest(json_message+secret_key)
      req.body = json_message
      req['Authorization'] = json_authorization

      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end

      p "======================================================================="
      p "Battle count tracking: #{res.body}"
      p "======================================================================="

    end
  end
  handle_asynchronously :track_performance



  def track_ability_frequency(name, user_id)
    if self.admin == false
      game_key = ENV["GAME_KEY"]
      secret_key = ENV["GAME_SECRET"]
      endpoint_url = "http://api.gameanalytics.com/1"
      category = "design"
      message = {}
      message["area"] = self.battle_level.name.gsub(" ", "_") 
      message["event_id"] = "abilities:" + name.gsub(" ", "_")
      message["user_id"] = user_id
      message["session_id"] = self.session_id
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
      p "Ability tracking: #{res.body}"
      p "======================================================================="
    end
  end
  handle_asynchronously :track_ability_frequency
end

