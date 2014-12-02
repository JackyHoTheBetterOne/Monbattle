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
  before_save :generate_code, :update_date

  scope :find_matching_date, -> (date, party) {
    joins(:fights).where(updated_on: date, "fights.party_id" => party.id)
  }

  scope :find_battles_on_date, -> (date) {
    where(updated_on: date)
  }

  aasm do
    state :battling, :initial => true
    state :complete, :before_enter => :battle_complete
    event :done, :after => :distribute_quest_reward do
      transitions :from => :battling, :to => :complete
    end
    event :ruined do 
      transitions :from => :battling, :to => :complete
    end
  end


####################################################################### End Battle Update
  def to_finish
    if self.aasm_state == "battling" && self.is_hacked == false
      self.done
    elsif self.is_hacked == true
      self.ruined
    end
  end
  
  def battle_complete
    @victor = self.victor
    victor_check
  end

  def victor_check
    if @victor == "NPC"
      @loser = Summoner.find_summoner(self.loser)
      @loser.losses += 1 
      @loser.save
    else
      give_reward
    end
    self.quest_update
  end

  def give_reward
    @mp_reward           = self.battle_level.mp_reward 
    @gp_reward           = self.battle_level.gp_reward 
    @vk_reward           = self.battle_level.vk_reward 
    @victorious_summoner = Summoner.find_summoner(@victor)

    @victorious_summoner.wins += 1 
    level_array = @victorious_summoner.beaten_levels.clone
    level_array.push(self.battle_level.name) if !level_array.include?self.battle_level.name

    @victorious_summoner.beaten_levels = level_array
    @victorious_summoner.mp += @mp_reward
    @victorious_summoner.gp += @gp_reward
    @victorious_summoner.vortex_key += @vk_reward
    @victorious_summoner.save
  end

  def quest_update
    if self.victor && self.loser
      @victor = Summoner.find_summoner(self.victor)
      @victor_party = @victor.party
      @loser = Summoner.find_summoner(self.loser)
      @loser_party = @loser.party
      @victor.check_quest
      @loser.check_quest
      @victor.add_daily_battle(self.id)
      @loser.add_daily_battle(self.id)
    end
  end

  def distribute_quest_reward
    if self.victor && self.loser
      @victor = Summoner.find_summoner(self.victor)
      @loser = Summoner.find_summoner(self.loser)
    end
    @victor.get_achievement
    @victor.get_login_bonus
    @loser.get_achievement
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
    self.battle_level.background.url(:cool)
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

  private
  def update_date
    self.updated_on = self.created_at
  end


  def generate_code
    if !self.id_code
      self.id_code = SecureRandom.uuid
    end
  end

end
