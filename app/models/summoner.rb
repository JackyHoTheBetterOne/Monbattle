class Summoner < ActiveRecord::Base
  belongs_to :user
  belongs_to :summoner_level

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :user_id, presence: {message: 'Must be entered'}, uniqueness: true

  before_create :set_beaten_levels

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


##################################################################################################### Quest logic

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
            q.stat_requirement
          @questing_summoner[q.reward] += q.reward_amount
          array = @questing_summoner.completed_daily_quests.clone
          array.push(q.name)
          @questing_summoner.completed_daily_quests = array
        end
      elsif q.type == "Daily-Turn-Based-Achievement" && (!@questing_summoner.completed_daily_quests.include?q.name) &&
        @questing_summoner.name != "NPC" && q.is_active
        successful_entries = []
        self.daily_battles.each do |b|
          battle = Battle.find(b)
          successful_entries.push(battle.id) if battle[q.stat].to_i < q.stat_requirement
        end
        if successful_entries.count == q.requirement
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
            q.stat_requirement
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

################################################################################################### Clearing entries

  def clear_daily_achievement
    self.completed_daily_quests = Array.new
    self.save
  end

  def clear_daily_battles
    self.daily_battles = Array.new
    self.save
  end

  def clear_recent_quests
    self.recently_completed_quests = Array.new
    self.save
  end

  def clear_recent_level
    self.recently_unlocked_level = nil
    self.save
  end

###################################################################################################### Quest display helpers
  def num_of_daily_wins
    count = 0 
    self.daily_battles.each do |b|
      battle = Battle.find(b)
      if battle.victor == self.name
        count += 1
      end
    end
    return count
  end

  def num_of_daily_wins_under_round(round)
    count = 0
    self.daily_battles.each do |b|
      battle = Battle.find(b)
      if battle.victor == self.name && battle.round <= round 
        count += 1
      end
    end
    return count 
  end




#############################################################################################################

  def add_daily_battle(battle_id)
    array = self.daily_battles.clone
    array.push(battle_id)
    self.daily_battles = array 
    self.save
  end

  private

  def set_beaten_levels
    self.beaten_levels = []
  end
end
