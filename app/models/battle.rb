class Battle < ActiveRecord::Base
  belongs_to :battle_level

  has_many :fights, dependent: :destroy
  has_many :parties, through: :fights

  validates :battle_level_id, presence: {message: 'Must be entered'}

  def build_json
    battle_json = {}
    battle_json[:background] = self.background
    battle_json[:battle_id] = self.id
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

end
