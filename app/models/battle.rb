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
  before_save :generate_code
  before_update :to_finish, :update_date, :quest_update
  before_create :update_date
  after_update :distribute_quest_reward   

  scope :find_matching_date, -> (date, party) {
    joins(:fights).where(updated_on: date, "fights.party_id" => party.id)
  }

  scope :find_battles_on_date, -> (date) {
    where(updated_on: date)
  }

  aasm do
    state :battling, :initial => true
    state :complete

    event :done do
      transitions :from => :battling, :to => :complete, :on_transition => :battle_complete
    end
  end


############################################# End Battle Update

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
  end

  def give_reward
    @mp_reward           = self.battle_level.mp_reward 
    @gp_reward           = self.battle_level.gp_reward 
    @vk_reward           = self.battle_level.vk_reward 
    @victorious_summoner = Summoner.find_summoner(@victor)

    @victorious_summoner.wins += 1 
    @victorious_summoner.mp += @mp_reward
    @victorious_summoner.gp += @gp_reward
    @victorious_summoner.vortex_key += @vk_reward
    @victorious_summoner.save
  end

#############################################

  def build_json
    battle_json = {}
    battle_json[:background] = self.background
    battle_json[:start_cut_scenes] = self.battle_level.start_cut_scenes
    battle_json[:end_cut_scenes] = self.battle_level.end_cut_scenes
    battle_json[:id] = self.id_code
    battle_json[:reward] = self.battle_level.mp_reward
    battle_json[:players] = []
    # self.users.each do |user|
    #   battle_json[:"#{user.user_name}"] = user.as_json
    # end

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

  def to_finish
    if self.aasm_state == "battling"
      self.done
    end
  end

  def quest_update
    if self.victor && self.loser
      @victor = Summoner.find_summoner(self.victor)
      @victor_party = @victor.party
      @loser = Summoner.find_summoner(self.loser)
      @loser_party = @loser.party
      @victor.check_quest
      @loser.check_quest
    end
  end

  def distribute_quest_reward
    if self.victor && self.loser
      @victor = Summoner.find_summoner(self.victor)
      @loser = Summoner.find_summoner(self.loser)
    end
    @victor.get_reward
    @loser.get_reward
  end
end
