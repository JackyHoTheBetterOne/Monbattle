class Summoner < ActiveRecord::Base
  belongs_to :user
  belongs_to :summoner_level

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :user_id, presence: {message: 'Must be entered'}, uniqueness: true

end
