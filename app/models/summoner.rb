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

  def self.quest_begin
    puts ">>>>>>>> STARTING QUEST BEGIN #{Time.now}"
    Summoner.all.each do |s|
      s.starting_status = s.serializable_hash 
      s.save
    end
  end
end
