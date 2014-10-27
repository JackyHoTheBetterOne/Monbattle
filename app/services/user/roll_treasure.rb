class RollTreasure
  include Virtus.model

  attribute :user, User 
  attribute :message


  def call
    @summoner = user.summoner             
    if @summoner.gp <= 5 
      self.message = "You ain't got no vortex key. Get more to roll."
      return self.message
    else 
      @summoner.vortex_key -= 5
      roll = Random.new
      reward_category_roll = roll.rand(1000)+1
      reward_level_roll = roll.rand(1000)+1
      case
        when (1..400).include?(reward_category_roll) #40% resource
          case
            when (1..370).include?(reward_level_roll) #37%
              @gp = 5
            when (371..620).include?(reward_level_roll) #25%
              @gp = 7
            when (621..820).include?(reward_level_roll) #20%
              @gp = 10
            when (821..920).include?(reward_level_roll) #10%
              @gp = 15
            when (921..975).include?(reward_level_roll) #5.5%
              @gp = 20
            when (976..1000).include?(reward_level_roll) #2.5%
              @gp = 30
            else
              return false
          end

          @summoner.gp += @gp 

          if @summoner.save
            self.message = "You won #{@gp} Genetic Points you stupid fuck"
            return self.message
          else
            return false
          end

        when (401..700).include?(reward_category_roll) #30% ability
          case
            when (1..820).include?(reward_level_roll) #82%
              @rarity = "common"
            when (821..920).include?(reward_level_roll) #10%
              @rarity = "rare"
            when (921..970).include?(reward_level_roll) #5%
              @rarity = "super rare"
            when (971..995).include?(reward_level_roll) #2.5%
              @rarity = "ultra rare"
            when (996..1000).include?(reward_level_roll) #.5%
              @rarity = "mythical"
            else
              return false
          end

          @abilities = Ability.includes(:rarity)
          @summoner.save 
          @abil_array = @abilities.worth(@rarity).pluck(:id)
          @abil_position = Random.new.rand(@abil_array.count)
          @abil_id_won = @abil_array[@abil_position]
          @abil_won_name = @abilities.find_name(@abil_id_won)

          if AbilityPurchase.unlock_check(@user, @abil_id_won).exists?
            self.message =  "You already own the ability #{@abil_won_name} that has rarity #{@rarity}, SO YOU GET NOTHING!"
            return self.message
          else 
            @ability_purchase = AbilityPurchase.new
            @ability_purchase.user_id = @user.id
            @ability_purchase.ability_id = @abil_id_won
            @ability_purchase.save
            self.message = "You unlocked ability #{@abil_won_name} that has rarity #{@rarity}!"
            return self.message
          end

        when (701..1000).include?(reward_category_roll) #30% monsters
          case
            when (1..820).include?(reward_level_roll) #82%
              @rarity = "common"
            when (821..920).include?(reward_level_roll) #10%
              @rarity = "rare"
            when (921..970).include?(reward_level_roll) #5%
              @rarity = "super rare"
            when (971..995).include?(reward_level_roll) #2.5%
              @rarity = "ultra rare"
            when (996..1000).include?(reward_level_roll) #.5%
              @rarity = "mythical"
            else
              return "hack attempt"
          end
          @monsters = Monster.base_mon #includes(:rarity)
          @summoner.save
          @mon_array = @monsters.worth(@rarity).pluck(:id)
          @mon_position = Random.new.rand(@mon_array.count)
          @mon_id_won = @mon_array[@mon_position]
          @mon_won_name = @monsters.find_name(@mon_id_won)

          #create_reward

          if MonsterUnlock.unlock_check(@user, @mon_id_won).exists?
            self.message =  "You already own the monster #{@mon_won_name} that has rarity #{@rarity}, SO YOU GET NOTHING!"
            return self.message
          else
            @monster_unlock = MonsterUnlock.new
            @monster_unlock.user_id = @user.id
            @monster_unlock.monster_id = @mon_id_won
            @monster_unlock.save
            self.message = "You unlocked monster #{@mon_won_name} that has rarity #{@rarity}!"
            return self.message
          end
        else
          return false
      end
    end
  end
end