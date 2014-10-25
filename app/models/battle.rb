class Battle < ActiveRecord::Base
  extend FriendlyId
  friendly_id :id_code
  belongs_to :battle_level
  has_many :fights, dependent: :destroy
  has_many :parties, through: :fights

  validates :battle_level_id, presence: {message: 'Must be entered'}
  before_save :generate_code

#############################################

  def battle_complete
    @victor = self.victor
    victor_check
  end

  def victor_check
    if @victor == "NPC"
    else
      give_reward
    end
  end

  def give_reward
    @mp_reward           = self.battle_level.mp_reward
    @gp_reward           = self.battle_level.gp_reward
    @victorious_summoner = Summoner.find_victorious_summoner(@victor)

    @victorious_summoner.mp += @mp_reward
    @victorious_summoner.gp += @gp_reward
    @victorious_summoner.save
  end

  ###########################################

  def build_json
    battle_json = {}
    battle_json[:background] = self.background
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
    self.battle_level.background.url(:large)
  end

  private
  def generate_code
    if !self.id_code
      self.id_code = SecureRandom.uuid
    end
  end

end
