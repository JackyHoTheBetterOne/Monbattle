class Summoner < ActiveRecord::Base
  belongs_to :user
  belongs_to :summoner_level

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :user_id, presence: {message: 'Must be entered'}, uniqueness: true

  include ActiveModel::Dirty

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


################################################################################################### Quest logic

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
      @summoner.completed_daily_quests = []
      self.ending_status = @summoner.serializable_hash
      self.save
    end
  end


  def get_achievement
    @questing_summoner = self
    Quest.all.each do |q|
      if q.type == "Daily-Achievement" && (!@questing_summoner.completed_daily_quests.include?q.name) && 
          @questing_summoner.name != "NPC" && q.is_active
        if (@questing_summoner.ending_status[q.stat].to_i - @questing_summoner.starting_status[q.stat].to_i) == 
            q.requirement
          @questing_summoner[q.reward] += q.reward_amount
          array = @questing_summoner.completed_daily_quests.clone
          array.push(q.name)
          @questing_summoner.completed_daily_quests = array
        end
      end
    end
    @questing_summoner.save
  end

  def get_login_bonus
    @questing_summoner = self
    Quest.all.each do |q|
      if q.type == "Daily-Login-Bonus" && (!@questing_summoner.completed_daily_quests.include?q.name) &&
        @questing_summoner.name != "NPC" && q.is_active
        if (@questing_summoner.ending_status[q.stat].to_i - @questing_summoner.starting_status[q.stat].to_i) <= 
            q.requirement
          @questing_summoner[q.reward] += q.reward_amount
        else
          array = @questing_summoner.completed_daily_quests.clone
          array.push(q.name)
          @questing_summoner.completed_daily_quests = array
        end
      end
    end
    @questing_summoner.save
  end


  def clear_daily_achievement
    self.completed_daily_quests = Array.new
    self.save
  end
end
