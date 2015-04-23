class Battle::End
  include Virtus.model
  attribute :battle, Battle

  def call
    @battle_level        = battle.battle_level
    @exp_reward          = battle.battle_level.exp_given
    @victorious_summoner = Summoner.find_summoner(battle.victor)
    @victorious_summoner.wins += 1 

    if @victorious_summoner.exp_required <= @exp_reward + @victorious_summoner.current_exp
      @victorious_summoner.current_exp = @exp_reward + @victorious_summoner.current_exp - 
        @victorious_summoner.exp_required 
      @level = SummonerLevel.find_by_level(@victorious_summoner.level+1)
      @victorious_summoner.summoner_level = @level
      @victorious_summoner.stamina = @level.stamina
      if @level.level == 7
        @user = @victorious_summoner.user
        @user.request_ids.each do |r|
          @user = User.select{|u| u.invite_ids.include?(r)}
          @summoner = @user.summoner
          array = @summoner.general_messages.dup
          @summoner.mp += 10
          array.push("#{@user.namey} has reached Level 7! You have gained 10 rubies!")
          @summoner.general_messages = array
          @summoner.save
        end
      end
    else
      @victorious_summoner.current_exp += @exp_reward
    end

    if @victorious_summoner.beaten_levels.include?(@battle_level.name) && !@battle_level.event
      if battle.round_taken < @battle_level.time_requirement && @battle_level.time_reward.length != 0
        @victorious_summoner[@battle_level.time_reward[0]] += battle.reward_num
      elsif battle.round_taken >= @battle_level.time_requirement && @battle_level.pity_reward.length != 0
        @victorious_summoner[@battle_level.pity_reward[0]] += battle.reward_num
      end
    end

    @victorious_summoner.save
    @victorious_summoner.check_quest
  end
end