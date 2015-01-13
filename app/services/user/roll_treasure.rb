class User::RollTreasure
  include Virtus.model

  attribute :user, User
  attribute :message

  def call
    @summoner = user.summoner
    if @summoner.gp < 100
      self.message = "You ain't got enough gp. Get more to roll."
      return self.message
    else
      chance = Rarity.find_by_name("common").chance
      @common_chance = (chance*10000).to_i
      chance = Rarity.find_by_name("rare").chance
      @rare_chance = (chance*10000).to_i
      chance = Rarity.find_by_name("super rare").chance
      @super_rare_chance = (chance*10000).to_i
      chance = Rarity.find_by_name("ultra rare").chance
      @ultra_rare_chance = (chance*10000).to_i
      chance = Rarity.find_by_name("latest").chance
      @latest_chance = (chance*10000).to_i
      @summoner.gp -= 100
      @summoner.save
      roll = Random.new
      reward_category_roll = roll.rand(1..1000)
      reward_level_roll = roll.rand(1..1000)


      case
        when (1..@common_chance).include?(reward_level_roll) #70%
          @rarity = "common"
        when ((@common_chance+1)..@rare_chance).include?(reward_level_roll) #20%
          @rarity = "rare"
        when ((@rare_chance+1)..@super_rare_chance).include?(reward_level_roll) #7%
          @rarity = "super rare"
        when ((@super_rare_chance-1)..@ultra_rare_chance).include?(reward_level_roll) #3%
          @rarity = "ultra rare"
        else
          return false
      end


      case
        when (1..970).include?(reward_category_roll) #97% ability
          @abil_array = Ability.can_win(@rarity).pluck(:id)

          if @rarity == "common"
            @latest_abil_array = Ability.can_win("latest").pluck(:id)
            chance = @latest_abil_array.count*@latest_chance
            ability_roll = Random.new.rand(1..1000)
            if (1..chance).include?(ability_roll)
              @rarity = "latest"
              @abil_array = @latest_mon_array
            end
          end

          @abil_id_won = @abil_array.sample
          @abil_won_name = Ability.find_name(@abil_id_won)[0]
          if @abil_id_won == nil
            self.message = "The #{@rarity} abilities are currently unavailable!"
            return self.message
          end

          AbilityPurchase.create(user_id: @user.id, ability_id: @abil_id_won)
          self.message = "You unlocked ability #{@abil_won_name}!"
          return self.message

        when (970..1000).include?(reward_category_roll) #3% monsters
          @mon_id_array = Monster.can_win(@rarity).pluck(:id)
          @id_array = []

          if @rarity == "common"
            @latest_mon_array = Monster.can_win("latest").pluck(:id)
            chance = @latest_mon_array.count*@latest_chance
            monster_roll = Random.new.rand(1..1000)
            if (1..chance).include?(monster_roll)
              @rarity = "latest"
              @mon_id_array = @latest_mon_array
            end
          end

          @mon_id_array.each do |d|
            @id_array << d if MonsterUnlock.unlock_check(@user, d).exists?
          end

          @mon_id_won = @id_array.sample
          @mon_won_name = @monsters.find_name(@mon_id_won)[0]

          if @mon_id_won == nil
            self.message = "You have unlocked all the #{@rarity} monsters!"
            return self.message
          end

          @monster_unlock = MonsterUnlock.new
          @monster_unlock.user_id = @user.id
          @monster_unlock.monster_id = @mon_id_won
          @monster_unlock.save
          self.message = "You unlocked monster #{@mon_won_name}!"
          return self.message
      end
    end
  end
end