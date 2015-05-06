class GuildEventReward
  attr_accessor :starting
  attr_accessor :ending
  attr_accessor :rewards

  def initialize(options = {})
    @starting = options[:starting] - 1
    @ending = options[:ending] - 1
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