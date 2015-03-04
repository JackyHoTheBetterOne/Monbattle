class User::RollTreasure
  include Virtus.model

  attribute :roll_type
  attribute :currency_type
  attribute :user, User
  attribute :description
  attribute :job_list
  attribute :cost
  attribute :message
  attribute :reward_name
  attribute :type
  attribute :rarity
  attribute :image
  attribute :rarity_image
  attribute :rarity_color
  attribute :first_time


  def call
    self.message = "1"
    self.reward_name = "1"
    self.type = "1"
    self.rarity = "1"
    self.image = "https://s3-us-west-2.amazonaws.com/monbattle/images/frank.jpg"
    self.rarity_image = "https://s3-us-west-2.amazonaws.com/monbattle/images/legendary-text.png"
    self.rarity_color = "1"
    self.description = ""
    self.job_list = ""

    if roll_type == "base"
      if currency_type == "gp"
        self.cost = 100
      else 
        self.cost = 5
      end
    elsif roll_type == "ascension"
      if currency_type == "gp"
        self.cost = 200
      else
        self.cost = 10
      end
    elsif roll_type == "monster"
      if currency_type == "gp"
        self.cost = 1000
      else
        self.cost = 50
      end
    end

    if user.ability_purchases.count == 4
      self.first_time = true
    else
      self.first_time = false
    end

    @summoner = user.summoner
    if @summoner[currency_type] < cost
      self.message = "You ain't got enough gp. Get more to roll."
      return self.message
    else
      chance = Rarity.find_by_name("common").chance
      @common_chance = (chance*1000).to_i
      chance = Rarity.find_by_name("rare").chance
      @rare_chance = (chance*1000).to_i
      chance = Rarity.find_by_name("super rare").chance
      @super_rare_chance = (chance*1000).to_i
      chance = Rarity.find_by_name("ultra rare").chance
      @ultra_rare_chance = (chance*1000).to_i
      chance = Rarity.find_by_name("latest").chance
      @latest_chance = (chance*1000).to_i
      @summoner[currency_type] -= cost
      @summoner.save

      reward_level_roll = Random.new.rand(1..1000)


      case
        when (1..@common_chance).include?(reward_level_roll) #70%
          p "==================================================="
          p @common_chance
          p reward_level_roll
          p "==================================================="
          @rarity = "common"
          @rarity_color = "-1px 1px 20px #30f3ff"
          @rarity_image = "https://s3-us-west-2.amazonaws.com/monbattle/images/common-text.png"
        when ((@common_chance+1)..(@common_chance+@rare_chance)).include?(reward_level_roll) #20%
          p "==================================================="
          p @common_chance+@rare_chance
          p reward_level_roll
          p "==================================================="
          @rarity = "rare"
          @rarity_color = "-1px 1px 20px #304dff"
          @rarity_image = "https://s3-us-west-2.amazonaws.com/monbattle/images/rare-text.png"
        when ((@common_chance+@rare_chance+1)..(@common_chance+@rare_chance+@super_rare_chance)).
                include?(reward_level_roll) #7%
          p "==================================================="
          p @common_chance+@rare_chance+@super_rare_chance
          p reward_level_roll
          p "==================================================="
          @rarity = "super rare"
          @rarity_color = "-1px 1px 20px #bd30ff"
          @rarity_image = "https://s3-us-west-2.amazonaws.com/monbattle/images/epic-text.png"
        when ((@common_chance+@rare_chance+@super_rare_chance+1)..1000).
                include?(reward_level_roll) #3%
          p "==================================================="
          p @common_chance+@rare_chance+@super_rare_chance+1
          p reward_level_roll
          p "==================================================="
          @rarity = "ultra rare"
          @rarity_color = "-1px 1px 20px #ffaa30"
          @rarity_image = "https://s3-us-west-2.amazonaws.com/monbattle/images/legendary-text.png"
        else
          return false
      end

      self.rarity_color = @rarity_color
      self.rarity = @rarity
      self.rarity_image = @rarity_image

      if roll_type != "monster"
        if roll_type == "base"
          @abil_array = Ability.base.can_win(@rarity).pluck(:id)
        elsif roll_type == "ascension"
          @abil_array = Ability.ascension.can_win(@rarity).pluck(:id)
        end

        if @rarity == "common"
          if roll_type == "base"
            @latest_abil_array = Ability.base.can_win("latest").pluck(:id)
          elsif roll_type == "ascension"
            @latest_abil_array = Ability.ascension.can_win("latest").pluck(:id)
          end
          chance = @latest_chance * @latest_abil_array.count
          ability_roll = Random.new.rand(1..1000)
          if (1..chance).include?(ability_roll)
            @rarity = "latest"
            @abil_array = @latest_abil_array
          end
        end

        @abil_id_won = @abil_array.sample
        @abil_won_name = Ability.find_name(@abil_id_won)[0]

        if @abil_id_won == nil
          self.message = "The #{@rarity} abilities are currently unavailable!"
          return self.message
        end

        AbilityPurchase.create!(user_id: user.id, ability_id: @abil_id_won)
        self.message = "You unlocked ability #{@abil_won_name}!"
        self.reward_name = @abil_won_name
        self.description = Ability.find(@abil_id_won).description
        self.job_list = Ability.find(@abil_id_won).job_list
        self.image = Ability.find(@abil_id_won).portrait.url(:thumb)
        self.type = "ability"
        return self.message
      else 
        @mon_id_array = Monster.can_win(@rarity).pluck(:id)
        @id_array = []

        if @rarity == "common"
          @latest_mon_array = Monster.can_win("latest").pluck(:id)
          chance = @latest_chance * @latest_mon_array.count
          monster_roll = Random.new.rand(1..1000)
          if (1..chance).include?(monster_roll)
            @rarity = "latest"
            @mon_id_array = @latest_mon_array
          end
        end

        @mon_id_array.each do |d|
          @id_array << d if !MonsterUnlock.unlock_check(user, d).exists?
        end

        if @id_array.length == 0
          self.message = "You have unlocked all the #{@rarity} monsters!"
          return self.message
        end


        @mon_id_won = @id_array.sample
        @mon_won_name = Monster.find(@mon_id_won).name
        self.reward_name = @mon_won_name
        self.type = "monster"
        self.description = Monster.find(@mon_id_won).description

        @monster_unlock = MonsterUnlock.new
        @monster_unlock.user_id = user.id
        @monster_unlock.monster_id = @mon_id_won
        @monster_unlock.save

        self.image = @monster_unlock.mon_portrait(user)
        self.message = "You unlocked monster #{@mon_won_name}!"

        return self.message
      end


      # case
      #   when (1..970).include?(reward_category_roll) #97% ability
      #     @abil_array = Ability.can_win(@rarity).pluck(:id)

      #     if @rarity == "common"
      #       @latest_abil_array = Ability.can_win("latest").pluck(:id)
      #       chance = @latest_abil_array.count*@latest_chance
      #       ability_roll = Random.new.rand(1..1000)
      #       if (1..chance).include?(ability_roll)
      #         @rarity = "latest"
      #         @abil_array = @latest_mon_array
      #       end
      #     end

      #     @abil_id_won = @abil_array.sample
      #     @abil_won_name = Ability.find_name(@abil_id_won)[0]
      #     if @abil_id_won == nil
      #       self.message = "The #{@rarity} abilities are currently unavailable!"
      #       return self.message
      #     end

      #     AbilityPurchase.create!(user_id: user.id, ability_id: @abil_id_won)
      #     self.message = "You unlocked ability #{@abil_won_name}!"
      #     self.reward_name = @abil_won_name
      #     self.image = Ability.find(@abil_id_won).portrait.url(:thumb)
      #     self.type = "ability"
      #     return self.message

        # when (970..1000).include?(reward_category_roll) #3% monsters
          # @mon_id_array = Monster.can_win(@rarity).pluck(:id)
          # @id_array = []

          # if @rarity == "common"
          #   @latest_mon_array = Monster.can_win("latest").pluck(:id)
          #   chance = @latest_mon_array.count*@latest_chance
          #   monster_roll = Random.new.rand(1..1000)
          #   if (1..chance).include?(monster_roll)
          #     @rarity = "latest"
          #     @mon_id_array = @latest_mon_array
          #   end
          # end

          # @mon_id_array.each do |d|
          #   @id_array << d if !MonsterUnlock.unlock_check(user, d).exists?
          # end

          # @mon_id_won = @id_array.sample
          # @mon_won_name = Monster.find(@mon_id_won).name
          # self.reward_name = @mon_won_name
          # self.type = "monster"

          # if @mon_id_won == nil
          #   self.message = "You have unlocked all the #{@rarity} monsters!"
          #   return self.message
          # end

          # @monster_unlock = MonsterUnlock.new
          # @monster_unlock.user_id = user.id
          # @monster_unlock.monster_id = @mon_id_won
          # @monster_unlock.save

          # self.image = @monster_unlock.mon_portrait(user)
          # self.message = "You unlocked monster #{@mon_won_name}!"
          # return self.message
      # end
    end
  end
end