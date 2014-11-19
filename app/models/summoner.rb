class Summoner < ActiveRecord::Base
  belongs_to :user
  belongs_to :summoner_level

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :user_id, presence: {message: 'Must be entered'}, uniqueness: true

def self.find_summoner(user_name)
  @user = find_user(user_name)
  Summoner.where(user_id: @user).first
end

def self.find_user(user_name)
  User.where(user_name: user_name)
end

end
