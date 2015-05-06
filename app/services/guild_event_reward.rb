class GuildEventReward
  attr_accessor :starting
  attr_accessor :ending
  attr_accessor :array

  def initialize(options = {})
    @starting = options[:starting]
    @ending = options[:ending]
    @rewards = []
  end

  def add_reward(reward)
    if reward.class == EventTierPrice
      @rewards << reward
    else
      warn "You have to insert an EventTierPrice object!"
    end
  end

end