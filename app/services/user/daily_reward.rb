class User::DailyReward
  include Virtus.model
  attribute :summoner, Summoner
  attribute :reward_logo
  attribute :reward_amount
  attribute :type

  def call
    self.reward_amount = ""
    if summoner.daily_reward_given_first == false || summoner.daily_reward_given_second == false
      if summoner.daily_reward_giving_time + 20.seconds >= Time.now
        type_array = ["enh", "asp", "gp"]
        reward_type = type_array.sample
        if !summoner.daily_reward_given_first
          self.reward_amount = Random.rand(5..10)
        else
          self.reward_amount = Random.rand(10..25)
        end
        summoner[reward_type] += reward_amount
        case reward_type
        when "enh"
          self.reward_logo = "https://s3-us-west-2.amazonaws.com/monbattle/images/enhance.png"
        when "asp"
          self.reward_logo = "https://s3-us-west-2.amazonaws.com/monbattle/images/ascend.png"
        when "gp"
          self.reward_logo = "https://s3-us-west-2.amazonaws.com/monbattle/images/gp.png"
        end
      end
    end
    if summoner.daily_reward_given_first == false && summoner.daily_reward_given_second == false
      self.type = "first"
      summoner.daily_reward_given_first = true
      summoner.daily_reward_giving_time = Time.now + 2.minutes
    elsif summoner.daily_reward_given_first
      self.type = "second"
      summoner.daily_reward_given_second = true
    end
    summoner.save
  end
end