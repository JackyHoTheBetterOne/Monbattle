class Battle < ActiveRecord::Base
  belongs_to :battle_level

  has_many :fights, dependent: :destroy
  has_many :parties, through: :fights

  validates :battle_level_id, presence: {message: 'Must be entered'}

  def build_json
    battle_json = {}
    battle_json[:battle_id] = self.id
    battle_json[:players] = []
    # self.users.each do |user|
    #   battle_json[:"#{user.user_name}"] = user.as_json
    # end
    self.users.each do |user|
      battle_json[:players] << user.parties[0].as_json
    end
    return battle_json
  end
end
