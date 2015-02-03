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

  def call
    self.ability = nil
    self.monster = nil
    self.reward = nil

    if summoner.beaten_levels.include?(battle_level.name) && 
        round_taken.to_i < battle_level.time_requirement &&
        !summoner.cleared_twice_levels.include?(battle_level.name)
      if battle_level.ability_reward.length != 0
        if battle_level.ability_reward[0] == "Ability"
          self.ability = Ability.find_by_name(battle_level.ability_reward[1])
        elsif battle_level.ability_reward[0] == "Monster"
          self.monster = Monster.find_by_name(battle_level.ability_reward[1])
        else
          self.reward = battle_level.ability_reward[0] + ": " + battle_level.ability_reward[1]
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
  end

end