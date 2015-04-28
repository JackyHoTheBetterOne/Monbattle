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

  scope :find_out_how_many_wins, -> (level_id, party_id) {
    joins(:parties).where("victor != 'NPC' AND battle_level_id = #{level_id} AND parties.id = #{party_id}")
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

########################################################################################################### Decorating

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
     end_battle = Battle::End.new(battle: self)
     end_battle.call
    end
    if self.battle_level.is_guild_level
      guild_battle = Battle::GuildBattle.new(battle: self)
      guild_battle.call
    end
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

  def build_json(party_id)
    level = self.battle_level
    level_id = level.id
    scaling = level.gbattle_weight_scaling
    count = Battle.find_out_how_many_wins(level_id, party_id).count
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

    if self.battle_level.is_guild_level && count > 0
      difficulty_multiplier = scaling**count
      battle_json[:players][1]["mons"].each do |m|
        health = m["hp"] * difficulty_multiplier
        m[:hp] = health.to_i
        m[:max_hp] = health.to_i
        m["abilities"].each do |a|
          number = a["change"].to_i
          new_number = number*difficulty_multiplier
          a["change"] = new_number.to_i
          a["effects"].each do |e|
            number = e["change"].to_i
            new_number = number*difficulty_multiplier
            e["change"] = new_number.to_i   
          end
        end
      end
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
      if self.victor == "NPC"
        event_id = "outcome:defeat"
      else
        event_id = "outcome:victory"
      end

      tracking = User::Tracking.new(battle: self, session_id: self.session_id, 
                                      event_id: event_id, value: 1, user_id: user_id)
      tracking.battle_side_tracking
      tracking.call
    end
  end
  handle_asynchronously :track_outcome



  def track_progress(user_id)
    if self.admin == false
      event_id = "level_unlock" + ":" + self.battle_level.name.gsub(" ", "_")
      unlock_tracking = User::Tracking.new(battle: self, session_id: self.session_id, 
                                            event_id: event_id, value: 1, user_id: user_id)
      unlock_tracking.battle_side_tracking
      unlock_tracking.call

      event_id = "level_unlock_user" + ":" + user_id
      user_unlock_tracking = User::Tracking.new(battle: self, session_id: self.session_id,
                                                  event_id: event_id, value: 1, user_id: user_id)
      user_unlock_tracking.battle_side_tracking
      user_unlock_tracking.call
    end
  end
  handle_asynchronously :track_progress



  def track_performance(user_id)
    if self.admin == false
      event_id_1 = "time_taken"
      value = self.time_taken
      time_tracking = User::Tracking.new(battle: self, session_id: self.session_id, 
                                          event_id: event_id_1, value: value, user_id: user_id)
      time_tracking.battle_side_tracking
      time_tracking.call

      event_id_2 = "turns_taken"
      value = self.round_taken
      turn_tracking = User::Tracking.new(battle: self, session_id: self.session_id, 
                                          event_id: event_id_2, value: value, user_id: user_id)
      turn_tracking.battle_side_tracking
      turn_tracking.call


      event_id_3 = "battle_finish_count"
      count_tracking = User::Tracking.new(battle: self, session_id: self.session_id, 
                                          event_id: event_id_3, value: 1, user_id: user_id)
      count_tracking.battle_side_tracking
      count_tracking.call
    end
  end
  handle_asynchronously :track_performance



  def track_ability_frequency(name, user_id)
    if self.admin == false
      event_id = "abilities:" + name.gsub(" ", "_")
      tracking = User::Tracking.new(battle: self, session_id: self.session_id, 
                                          event_id: event_id, value: 1, user_id: user_id)
      tracking.battle_side_tracking
      tracking.call
    end
  end
  handle_asynchronously :track_ability_frequency
end

