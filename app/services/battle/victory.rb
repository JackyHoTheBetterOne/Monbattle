class Battle::Victory
  include Virtus.model

  attribute :battle_level, BattleLevel
  attribute :summoner, Summoner
  attribute :ability, Ability
  attribute :monster, Monster
  attribute :reward
  attribute :round_taken 
  attribute :slot
  attribute :class_list
  attribute :level_cleared

  attribute :level_up
  attribute :new_level
  attribute :stamina_upgrade
  attribute :new_stamina

  attribute :first_time

  def call
    self.ability = nil
    self.monster = nil
    self.reward = nil
    @user = summoner.user

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


    if !summoner.beaten_levels.include?(battle_level.name) && !summoner.cleared_twice_levels.include?(battle_level.name)
      if battle_level.ability_reward.length != 0
        if battle_level.ability_reward[0] == "ability"
          self.ability = Ability.find_by_name(battle_level.ability_reward[1])
        elsif battle_level.ability_reward[0] == "monster"
          self.monster = Monster.find_by_name(battle_level.ability_reward[1])
        else
          self.reward = battle_level.ability_reward[0] + ": " + battle_level.ability_reward[1]
        end
      end
    elsif summoner.cleared_twice_levels.include?(battle_level.name)
      self.reward = battle_level.second_clear_reward
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
  end
end