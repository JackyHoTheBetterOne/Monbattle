class Summoner < ActiveRecord::Base
  belongs_to :user
  belongs_to :summoner_level

  validates :user_id, presence: {message: 'Must be entered'}, uniqueness: true
  validates :facebook_id, uniqueness: true, allow_nil: true

  before_save :check_energy
  before_save :generate_code
  after_create :change_name

  belongs_to :led_guild, class_name: "Guild", foreign_key: "led_guild_id"
  belongs_to :sub_led_guild, class_name: "Guild", foreign_key: "sub_led_guild_id"
  belongs_to :guild, class_name: "Guild"
  has_many :guild_messeages

  has_many :notifications, as: :notificapable, dependent: :destroy
  has_many :scores, as: :scorapable, dependent: :destroy

  has_many :avatars, dependent: :destroy


  scope :friend_scores, -> (*names) {
    includes(:scorapable).where("scorapable_type = 'Summoner'").where(scorapable: {name: names})
  }

  # scope :friends, -> (facebook_ids) {
  #   where(:facebook_id => facebook_ids)
  # }

  scope :friends, -> (facebook_ids) {
    where(:name => facebook_ids)
  }

################################################################################################ Decoration

  def daily_bonus_time_left
    (self.daily_reward_giving_time - Time.now).to_i
  end


  def guild_title(guild)
    if guild.leader == self
      return "Leader"
    elsif guild.sub_leaders.include?self
      "Sub-leader"
    else 
      return false
    end
  end

  def is_leader(guild) 
    if guild.leader == self
      return true
    else
      return false
    end
  end

  def is_member(guild)
    if guild.members.include?self
      return true
    else
      return false
    end
  end


  def true_name
    self.user.namey
  end


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
    @questing = User::QuestReward.new(summoner: self)
    @questing.call
  end

  def get_login_bonus_for_wins
    @questing = User::LoginBonus.new(summoner: self)
    @questing.call
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

