class Summoner < ActiveRecord::Base
  belongs_to :user
  belongs_to :summoner_level

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :user_id, presence: {message: 'Must be entered'}, uniqueness: true

def self.find_victorious_summoner(user_name)
  @user_id = find_user_id(user_name)
  Summoner.where(user_id: @user_id).first
end

def self.find_user_id(user_name)
  User.where(user_name: user_name)
end

end
