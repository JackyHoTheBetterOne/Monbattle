require 'aasm'

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

  scope :find_matching_date, -> (date, party) {
    joins(:fights).where(finished: date, "fights.party_id" => party.id)
  }

  aasm do
    state :battling, :initial => true
    state :hacked
    state :complete, :after_enter => :victor_check

    event :done do
      transitions :from => :battling, :to => :complete
    end

    event :ruined do 
      transitions :from => :battling, :to => :hacked
    end
  end

####################################################################### End Battle Update
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
      @loser.losses += 1 
      @loser.save
    else
      give_reward
    end
  end

  def give_reward
    @battle_level        = self.battle_level
    @mp_reward           = self.battle_level.mp_reward 
    @gp_reward           = self.battle_level.gp_reward 
    @vk_reward           = self.battle_level.vk_reward 
    @victorious_summoner = Summoner.find_summoner(self.victor)

    @victorious_summoner.wins += 1 
    @victorious_summoner.mp += @mp_reward
    @victorious_summoner.gp += @gp_reward
    @victorious_summoner.vortex_key += @vk_reward
    
    @victorious_summoner.save
    self.quest_update
  end

  def quest_update
    @victor = Summoner.find_summoner(self.victor)
    @loser = Summoner.find_summoner(self.loser)
    @victor.check_quest
    @loser.check_quest
    @victor.add_daily_battle(self.id)
    @loser.add_daily_battle(self.id)
    @victor.save
    @loser.save
    self.distribute_quest_reward
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


##############################################################################################################

  def build_json
    battle_json = {}
    battle_json[:background] = self.background
    battle_json[:start_cut_scenes] = self.battle_level.start_cut_scenes
    battle_json[:end_cut_scenes] = self.battle_level.end_cut_scenes
    battle_json[:id] = self.id_code
    battle_json[:reward] = self.battle_level.mp_reward
    battle_json[:players] = []

    self.parties.order(:npc).each do |party|
      battle_json[:players] << party.as_json
    end

    return battle_json
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

  def update_date
    if self.created_at
      self.finished = self.created_at.in_time_zone("Pacific Time (US & Canada)").to_date
    end
  end

  private

  def generate_code
    self.id_code = SecureRandom.uuid
  end
end
