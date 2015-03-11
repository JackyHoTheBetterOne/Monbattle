class Battle::Victory
  include Virtus.model

  attribute :battle_level, BattleLevel
  attribute :battle, Battle
  attribute :summoner, Summoner
  attribute :ability, Ability
  attribute :monster, Monster
  attribute :reward_num
  attribute :reward
  attribute :reward_image
  attribute :reward_category
  attribute :first_cleared
  attribute :round_taken 
  attribute :slot
  attribute :class_list
  attribute :level_cleared

  attribute :level_up
  attribute :new_level
  attribute :stamina_upgrade
  attribute :new_stamina
  attribute :reward_tier


  attribute :first_time
  attribute :share_message



  def call
    self.ability = nil
    self.monster = nil
    self.reward = nil
    self.reward_tier = nil
    @user = summoner.user

    if summoner.beaten_levels.include? battle_level.name
      self.first_cleared = false
    else
      self.first_cleared = true
    end


    if battle_level.exp_given + summoner.current_exp >= summoner.exp_required
      self.level_up = true
      self.new_level = summoner.level + 1
      level_object = SummonerLevel.find_by_level(self.new_level)
      if level_object.stamina > summoner.max_stamina
        self.stamina_upgrade = true
        self.new_stamina = level_object.stamina
      else
        self.stamina_upgrade = false
        self.new_stamina = nil
      end

    else
      self.level_up = false
      self.new_level = nil
      self.stamina_upgrade = nil
      self.new_stamina = nil
    end

    if battle_level.event
      number = rand(1..100)
      if battle_level.ability_reward.length != 0
        monster = Monster.find_by_name(battle_level.ability_reward[1])
        monster_id = monster.id
        array = MonsterUnlock.where("user_id = #{summoner.user.id} AND monster_id = #{monster_id}")
        if array.length == 0 && (1..battle_level.ability_reward[2].to_i).include?(number)
          self.monster = monster
          self.reward_image = battle_level.first_clear_reward_image
          self.reward_tier = "first"
        elsif (1..battle_level.time_reward[2].to_i).include?(number)
          self.ability = Ability.find_by_name(battle_level.time_reward[1])
          self.reward_image = battle_level.second_clear_reward_image
          self.reward_tier = "second"
        else
          self.reward = "x" + " " + self.reward_num.to_s
          self.reward_image = battle_level.pity_reward_image
          self.reward_tier = "third"
        end
      elsif (1..battle_level.time_reward[2].to_i).include?(number)
        self.ability = Ability.find_by_name(battle_level.time_reward[1])
        self.reward_tier = "second"
      else
        self.reward = "x" + " " + self.reward_num.to_s
        self.reward_image = battle_level.pity_reward_image
        self.reward_tier = "third"
      end
    else
      if !summoner.beaten_levels.include?(battle_level.name) && !summoner.cleared_twice_levels.include?(battle_level.name)
        if battle_level.ability_reward.length != 0
          self.reward_image = battle_level.first_clear_reward_image
          if battle_level.ability_reward[0] == "ability"
            self.ability = Ability.find_by_name(battle_level.ability_reward[1])
          elsif battle_level.ability_reward[0] == "monster"
            self.monster = Monster.find_by_name(battle_level.ability_reward[1])
          else
            self.reward = "x" + " " + battle_level.ability_reward[1].to_s
          end
        end
      elsif summoner.beaten_levels.include?(battle_level.name)  
        if battle_level.time_requirement
          self.reward = "x" + " " + self.reward_num.to_s
          if round_taken.to_i < battle_level.time_requirement.to_i
            self.reward_image = battle_level.second_clear_reward_image
          else
            self.reward_image = battle_level.pity_reward_image
          end 
        end
      end
    end

    self.class_list = ""
    self.slot = ""
    array = []

    if self.ability != nil
      self.ability.ability_restrictions.each do |a|
        if a.job.name.index("NPC") == nil
          array.push(a.job.name)
        end
      end
      self.class_list = array.join(", ")
      if self.ability.targeta == "attack"
        self.slot = "Attack"
      else
        self.slot = "Skill"
      end
    end

    if summoner.beaten_levels.include?battle_level.name
      self.level_cleared = true
    else
      self.level_cleared = false
    end

    if self.ability != nil 
      if @user.ability_purchases.count == 4 
        self.first_time = true
      else 
        self.first_time = false
      end
    else
      self.first_time == false
    end

    if self.ability != nil 
      self.reward_category = "ability"
    elsif self.monster != nil
      self.reward_category = "monster"
    elsif self.reward_image == "https://s3-us-west-2.amazonaws.com/monbattle/images/gp.png" ||
        self.reward_image == "https://s3-us-west-2.amazonaws.com/monbattle/images/mp.png"
      self.reward_category = "store"
    elsif self.reward_image == "https://s3-us-west-2.amazonaws.com/monbattle/images/ascend.png"
      self.reward_category = "ascend"
    elsif self.reward_image == "https://s3-us-west-2.amazonaws.com/monbattle/images/enhance.png"
      self.reward_category = "enhance"
    end

    if self.reward_category == "monster" or self.reward_category == "ability"
      self.share_message = summoner.user.first_name + " has beaten " + battle_level.name + " in " + 
                            battle_level.area.region.name + " and has unlocked a new " + self.reward_category + ", " +
                            self[self.reward_category].name + "!"
    else
      self.share_message = summoner.user.first_name + " has beaten " + battle_level.name + " in " + 
                            battle_level.area.region.name + " !"
    end


  end
end