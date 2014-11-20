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

  def battles
    self.user.parties[0].fights.each do |f|
      battles = []
      battles << f.battle
      return battles  
    end
  end

  def party
    self.user.parties[0]
  end

  def quest_begin
    unless self.name == "NPC"
      @summoner = self.clone
      @summoner.starting_status = {}
      @summoner.ending_status = {}
      self.starting_status = @summoner.serializable_hash
      self.save
    end
  end

  def check_quest
    unless self.name == "NPC"
      @summoner = self.clone
      @summoner.starting_status = {}
      @summoner.ending_status = {}
      self.ending_status = @summoner.serializable_hash
      self.save
    end
  end

end
