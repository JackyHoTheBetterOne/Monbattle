class SummonerLevel < ActiveRecord::Base

  has_many :summoners

  validates :lvl, presence: {message: 'Must be entered'}, uniqueness: true
  validates :exp_to_nxt_lvl, presence: {message: 'Must be entered'}
  validates :monsters_allowed, presence: {message: 'Must be entered'}
  validates :ap, presence: {message: 'Must be entered'}
end
