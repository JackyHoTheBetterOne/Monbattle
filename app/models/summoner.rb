class Summoner < ActiveRecord::Base
  belongs_to :user
  belongs_to :summoner_level

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :user_id, presence: {message: 'Must be entered'}, uniqueness: true

  def give_reward(mp_reward, gp_reward)
    self.mp += mp_reward
    self.gp += gp_reward
    self.save
  end

end
