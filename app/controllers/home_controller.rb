class HomeController < ApplicationController
  layout "facebook_landing", except: [:index]

  def index
    @base_mons = MonsterUnlock.base_mons(current_user)
    @abilities = Ability.all
    @ability_equippings = AbilityEquipping.all
    @members = current_user.parties.first.members
  end

  def show
  end

  def store
    @abilities = Ability.all.order(:created_at).limit(8)
  end

  def facebook
  end

  def level_select
    render new_battle_path, layout: "facebook_landing"
  end

  def illegal_access
  end

  # def roll
  #   rolling = Home::RollTreasure(user: current_user)
  #   rolling.call

  #   @user = current_user
  #   @summoner = @user.summoner

  #   #remove ticket from current user then execute

  #   if @summoner.vortex_key <= 0
  #     render text: "No keys to open this vortex, spend your life savings to buy more!"
  #   else
  #     @summoner.vortex_key -= 1

  #     roll = Random.new
  #     reward_category_roll = roll.rand(1000) + 1
  #     reward_level_roll = roll.rand(1000) + 1

  #     case

  #       when (1..850).include?(reward_category_roll) #85% resource

  #         case
  #           when (1..370).include?(reward_level_roll) #37%
  #             @gp = 5
  #           when (371..620).include?(reward_level_roll) #25%
  #             @gp = 7
  #           when (621..820).include?(reward_level_roll) #20%
  #             @gp = 10
  #           when (821..920).include?(reward_level_roll) #10%
  #             @gp = 15
  #           when (921..975).include?(reward_level_roll) #5.5%
  #             @gp = 20
  #           when (976..1000).include?(reward_level_roll) #2.5%
  #             @gp = 30
  #           else
  #             return "hack attempt"
  #         end

  #         @summoner.gp += @gp
  #         if @summoner.save
  #           render text: "You won #{@gp} Genetic Points you silly fuck"
  #         else
  #         end
  #         #update a database with results

  #       when (851..950).include?(reward_category_roll) #10% ability

  #         case
  #           when (1..820).include?(reward_level_roll) #82%
  #             @rarity = "common"
  #           when (821..920).include?(reward_level_roll) #10%
  #             @rarity = "rare"
  #           when (921..970).include?(reward_level_roll) #5%
  #             @rarity = "super rare"
  #           when (971..995).include?(reward_level_roll) #2.5%
  #             @rarity = "ultra rare"
  #           when (996..1000).include?(reward_level_roll) #.5%
  #             @rarity = "legendary"
  #           else
  #             return "hack attempt"
  #         end

  #         @abilities = Ability.includes(:rarity)
  #         @ability_purchases = AbilityPurchase.all
  #         @summoner.save

  #         @abil_array = @abilities.worth(@rarity).pluck(:id)
  #         @abil_position = Random.new.rand(@abil_array.count)
  #         @abil_id_won = @abil_array[@abil_position]
  #         @abil_won_name = @abilities.find_name(@abil_id_won)

  #         if @ability_purchases.unlock_check(@user, @abil_id_won).exists?
  #           render text: "You already own the ability #{@abil_won_name} that has rarity #{@rarity}, SO YOU GET NOTHING!"
  #         else
  #           @ability_purchase = AbilityPurchase.new
  #           @ability_purchase.user_id = @user.id
  #           @ability_purchase.ability_id = @abil_id_won
  #           @ability_purchase.save
  #           render text: "You unlocked ability #{@abil_won_name} that has rarity #{@rarity}!"
  #         end

  #       when (951..1000).include?(reward_category_roll) #5% monsters

  #         case
  #           when (1..820).include?(reward_level_roll) #82%
  #             @rarity = "common"
  #           when (821..920).include?(reward_level_roll) #10%
  #             @rarity = "rare"
  #           when (921..970).include?(reward_level_roll) #5%
  #             @rarity = "super rare"
  #           when (971..995).include?(reward_level_roll) #2.5%
  #             @rarity = "ultra rare"
  #           when (996..1000).include?(reward_level_roll) #.5%
  #             @rarity = "legendary"
  #           else
  #             return "hack attempt"
  #         end

  #           @monsters = Monster.base_mon #includes(:rarity)
  #           @monster_unlocks = MonsterUnlock.all
  #           @summoner.save

  #           @mon_array = @monsters.worth(@rarity).pluck(:id)
  #           @mon_position = Random.new.rand(@mon_array.count)
  #           @mon_id_won = @mon_array[@mon_position]
  #           @mon_won_name = @monsters.find_name(@mon_id_won)

  #           #create_reward

  #           if @monster_unlocks.unlock_check(@user, @mon_id_won).exists?
  #             render text: "You already own the monster #{@mon_won_name} that has rarity #{@rarity}, SO YOU GET NOTHING!"
  #           else
  #             @monster_unlock = MonsterUnlock.new
  #             @monster_unlock.user_id = @user.id
  #             @monster_unlock.monster_id = @mon_id_won
  #             @monster_unlock.save
  #             render text: "You unlocked monster #{@mon_won_name} that has rarity #{@rarity}!"
  #           end
  #       else
  #         return "hack attempt"

  #     end

  #   end #Ending the if/else statement for vortex key check

  # end

  private

end
