class Summoner < ActiveRecord::Base
  belongs_to :user
  belongs_to :summoner_level

  validates :name, presence: {message: 'Must be entered'}
  validates :description, presence: {message: 'Must be entered'}
  validates :user_id, presence: {message: 'Must be entered'}
  validates :summoner_level_id, presence: {message: 'Must be entered'}
end
