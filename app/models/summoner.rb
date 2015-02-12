class Summoner < ActiveRecord::Base
  belongs_to :user
  belongs_to :summoner_level

  validates :user_id, presence: {message: 'Must be entered'}, uniqueness: true

  before_save :check_energy
  before_save :generate_code
  after_create :change_name


  def level
    self.summoner_level.level
  end

  def max_stamina
    self.summoner_level.stamina
  end

  def exp_required
    self.summoner_level.exp_required_for_next_level
  end

  def exp_required_further
    return SummonerLevel.find_by_level(self.level+1).exp_required_for_next_level
  end

  def exp_percentage
    return (100*self.current_exp/self.exp_required).to_s + "%"
  end


  def change_name
    if self.name == nil 
      self.name = self.user.user_name
      self.save
    end
  end

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

  def stamina_percentage
    return (100*self.stamina/self.max_stamina).to_s + "%"
  end


############################################################################################ Quest logic
  def check_quest
    unless self.name == "NPC"
      @summoner = self.dup
      @summoner.starting_status = {}
      @summoner.ending_status = {}
      @summoner.completed_daily_quests = []
      self.ending_status = @summoner.serializable_hash
      self.save
    end
  end

  def get_achievement
    @questing_summoner = self
    array = @questing_summoner.completed_daily_quests.dup
    completion_array = @questing_summoner.just_achieved_quests.dup
    Quest.all.each do |q|
      if q.type == "Daily-Achievement" && (!@questing_summoner.completed_daily_quests.include?q.name) && 
          @questing_summoner.name != "NPC" && q.is_active
        if (@questing_summoner.ending_status[q.stat].to_i - @questing_summoner.starting_status[q.stat].to_i) >= 
            q.stat_requirement
          @questing_summoner[q.reward] += q.reward_amount
          array.push(q.name)
          completion_array.push(q.message)
        end
      elsif q.type == "Daily-Turn-Based-Achievement" && (!@questing_summoner.completed_daily_quests.include?(q.name)) &&
        @questing_summoner.name != "NPC" && q.is_active
        successful_entries = []
        self.daily_battles.each do |b|
          battle = Battle.find(b)
          successful_entries.push(battle.id) if battle[q.stat].to_i < q.stat_requirement && battle.victor != "NPC"
        end
        if successful_entries.count >= q.requirement.to_i
          @questing_summoner[q.reward] += q.reward_amount
          array.push(q.name)
          completion_array.push(q.message)
        end
      end
    end
    @questing_summoner.completed_daily_quests = array
    @questing_summoner.just_achieved_quests = completion_array
    @questing_summoner.save
  end

  def get_login_bonus_for_wins
    @questing_summoner = self
    array = @questing_summoner.completed_daily_quests.dup
    completion_array = @questing_summoner.just_achieved_quests.dup
    Quest.all.each do |q|
      if q.type == "Daily-Login-Bonus" && (!@questing_summoner.completed_daily_quests.include?q.name) &&
        @questing_summoner.name != "NPC" && q.is_active
        if (@questing_summoner.ending_status[q.stat].to_i - @questing_summoner.starting_status[q.stat].to_i) <= 
            q.stat_requirement
          p "================================================================================================"
          p @questing_summoner.ending_status[q.stat]
          p @questing_summoner.starting_status[q.stat]
          p q.stat_requirement
          p "================================================================================================="
          @questing_summoner[q.reward] += q.reward_amount
        end
        if (@questing_summoner.ending_status[q.stat].to_i - @questing_summoner.starting_status[q.stat].to_i) >= 
            q.stat_requirement
          array.push(q.name)
          completion_array.push(q.message)
          @questing_summoner.completed_daily_quests = array
          @questing_summoner.just_achieved_quests = completion_array
        end
      end
    end
    @questing_summoner.save
  end

##################################################################################### Clearing entries

  def quest_begin
    unless self.name == "NPC"
      @summoner = self.dup
      @summoner.starting_status = {}
      @summoner.ending_status = {}
      self.starting_status = @summoner.serializable_hash
      self.save
    end
  end
  

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
    self.recently_unlocked_level = ""
    self.save
  end

  def clear_just_achieved_quests
    self.just_achieved_quests = []
    self.save
  end

###################################################################################### Quest display helpers
  def num_of_daily_wins
    count = 0 
    self.daily_battles.each do |b|
      battle = Battle.find(b)
      @user = User.find_by_user_name(battle.victor)
      if @user.namey == self.name
        count += 1
      end
    end
    return count
  end

  def num_of_daily_wins_under_round(round)
    count = 0
    self.daily_battles.each do |b|
      battle = Battle.find(b)
      @user = User.find_by_user_name(battle.victor)
      if @user.namey == self.name && battle.round_taken < round 
        count += 1
      end
    end
    return count 
  end

  def check_completed_daily_quest(name)
    !self.completed_daily_quests.include?name
  end

  def generate_code
    if self.code == nil
      self.code = SecureRandom.uuid
    end
  end

#############################################################################################################
  def check_energy
    if self.name != "NPC"
      if self.last_update_for_energy != nil
        seconds = ((Time.now.in_time_zone("Pacific Time (US & Canada)") - 
                    self.last_update_for_energy.in_time_zone("Pacific Time (US & Canada)"))%300).to_i
        self.stamina += ((Time.now.in_time_zone("Pacific Time (US & Canada)") - 
                      self.last_update_for_energy.in_time_zone("Pacific Time (US & Canada)"))/300).floor.to_i
        self.last_update_for_energy = Time.now.in_time_zone("Pacific Time (US & Canada)") - seconds
        self.seconds_left_for_next_energy = 300 - seconds
        self.stamina = self.max_stamina if self.stamina > self.max_stamina
      else
        self.last_update_for_energy = Time.now.in_time_zone("Pacific Time (US & Canada)")
      end 
    end
  end
end

