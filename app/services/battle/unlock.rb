class Battle::Unlock
  include Virtus.model
  attribute :summoner, Summoner
  attribute :battle, Battle
  attribute :level, BattleLevel
  attribute :round_taken

  def call
    @summoner = self.summoner
    @user = @summoner.user
    @battle = self.battle
    level = @battle.battle_level

    ability_reward_array = level.ability_reward
    level_name = level.name
    cleared_twice_level_array = @summoner.cleared_twice_levels.dup

    if @summoner.name != "NPC"
      if !level.event
        if @summoner.beaten_levels.include?(level_name) && !cleared_twice_level_array.include?(level_name) 
          cleared_twice_level_array.push(level_name) 
        end
        if !@summoner.beaten_levels.include?(level_name) && ability_reward_array.length != 0 &&
            !cleared_twice_level_array.include?(level_name) 
          if ability_reward_array[0] == "ability"
            ability = Ability.find_by_name(ability_reward_array[1])
            ability_id = ability.id 
            user_id = @summoner.user.id
            AbilityPurchase.create!(ability_id: ability_id, user_id: user_id)
          elsif ability_reward_array[0] == "monster"
            monster = Monster.find_by_name(ability_reward_array[1])
            monster_id = monster.id 
            user_id = @summoner.user.id
            if MonsterUnlock.where(monster_id: monster_id, user_id: user_id).length == 0
              MonsterUnlock.create!(monster_id: monster_id, user_id: user_id) 
            end
          elsif ability_reward_array.length == 2
            @summoner[ability_reward_array[0]] += ability_reward_array[1].to_i
          end
        end
      else 
        if @battle.event_reward_tier == "first"
          monster_id = Monster.find_by_name(level.ability_reward[1]).id
          MonsterUnlock.create!(monster_id: monster_id, user_id: @user.id) 
        elsif @battle.event_reward_tier == "second"
          ability_id = Ability.find_by_name(level.time_reward[1]).id
          AbilityPurchase.create!(ability_id: ability_id, user_id: @user.id)
        else
          @summoner[level.pity_reward[0]] += @battle.reward_num
        end
      end

      level_array = @summoner.beaten_levels.dup
      area_array = @summoner.completed_areas.dup
      region_array = @summoner.completed_regions.dup

      if !level_array.include?level.name
        level_array.push(level.name) 
        @battle.track_progress(@user.id)
        unlocked_level = BattleLevel.where(unlocked_by_id: level.id)[0]
        if unlocked_level
          @summoner.recently_unlocked_level = unlocked_level.name 
          @summoner.latest_level = unlocked_level.name.gsub(" ","")
        end
      end

      if !area_array.include?level.area.name
        area_cleared = 0
        level.area.battle_levels.each do |b|
          if !level_array.include?b.name
            area_cleared = false
          end
        end

        if area_cleared != false
          area_array.push(level.area.name)
          latest_level_name = Area.find_by_unlocked_by_id(level.area.id).battle_levels.
            first.name.gsub(" ", "") if Area.find_by_unlocked_by_id(level.area.id)
          @summoner.latest_level = latest_level_name
        end
      end

      if !level.event
        if !region_array.include?level.area.region.name
          region_cleared = 0
          level.area.region.areas.each do |a|
            if !area_array.include?a.name
              region_cleared = false
            end
          end

          if region_cleared != false
            region_array.push(level.area.region.name)
            latest_level_name = Region.find_by_unlocked_by_id(1).areas.first.battle_levels.
              first.name.gsub(" ", "") if Region.find_by_unlocked_by_id(level.area.region.id)
            @summoner.latest_level = latest_level_name
          end
        end
      end

      @summoner.cleared_twice_levels = cleared_twice_level_array
      @summoner.beaten_levels = level_array
      @summoner.completed_areas = area_array
      @summoner.completed_regions = region_array
      @summoner.save
    end
  end
end