class User::RollTreasure
  include Virtus.model

  attribute :user, User
  attribute :message


  def call
    @summoner = user.summoner
    if @summoner.gp <= 5
      self.message = "You ain't got no gp. Get more to roll."
      return self.message
    else
      @summoner.gp -= 5
      @summoner.save
      roll = Random.new
      reward_category_roll = roll.rand(1..1000)
      reward_level_roll = roll.rand(1..1000)
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
          @summoner.save
          self.message = "You won #{@gp} Genetic Points, go roll some more!"
          return self.message

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

          @abil_id_won = Ability.can_win(@rarity).pluck(:id).sample
          @abil_won_name = @abilities.find_name(@abil_id_won)

          if @abil_id_won == nil
            self.message = "The #{@rarity} abilities are currently unavailable!"
            return self.message
          end

          AbilityPurchase.create(user_id: @user.id, ability_id: @abil_id_won)
          self.message = "You unlocked ability #{@abil_won_name}!"
          return self.message

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

          @mon_id_array = Monster.can_win(@rarity).pluck(:id)
          @id_array = []

          @mon_id_array.each do |d|
            @id_array << d if MonsterUnlock.unlock_check(@user, d).exists?
          end

          @mon_id_won = @id_array.sample
          @mon_won_name = @monsters.find_name(@mon_id_won)

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