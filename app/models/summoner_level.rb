class SummonerLevel < ActiveRecord::Base

  has_many :summoners

  validates :level, presence: {message: 'Must be entered'}, uniqueness: true
  validates :stamina, presence: {message: 'Must be entered'}
  validates :exp_required_for_next_level, presence: true
end
