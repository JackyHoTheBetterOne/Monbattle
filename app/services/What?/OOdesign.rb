
class RewardCategory
  attr_reader :roll

  def initialize
  @roll = Random.new.rand(1000)+1
  end

  def category
    case roll
      when (1..850) #85%
        "resource"
      when (851..950) #10%
        "ability"
      when (951..1000) #5%
        "monster"
      else
        false
    end
  end

end

class RewardLevel
  attr_reader :roll

  def initialize
  @roll = Random.new.rand(1000)+1
  end

  def level
    case roll
      when (1..250) #25%
        @gp = 5
      when (1..100) #25%
        @gp = 7
      when (101..150) #20%
        @gp = 10
      when (151..200) #10%
        @gp = 15
      when (201..250) #5.5%
        @gp = 20
      when (976..1000) #2.5%
        @gp = 30
      else
        false
    end
  end
end

RewardReceieved.new(
  reward_category: RewardCategory.new,
  reward_level:    RewardLevel.new)

class RewardRecieved
  attr_reader :reward_category
  attr_reader :reward_level
  attr_reader :category_roll
  attr_reader :rarity_roll
  attr_reader :prize_category

  def initialize(args)
    @reward_category = args[:reward_category]
    @reward_level    = args[:reward_level]


    @category_roll   = Random.new.rand(1..1000)+1
    @rarity_roll     = Random.new.rand(1..1000)+1
    @user_id         = user_id
    @categories      = { summoners: (1..25),
                          monsters: (25..50),
                          abilites: (51.. 100) }
    @reward_level_for_abilities = { common: (1..75),
                                      rare: (76..85) }

    self.category
  end

  def category
    case category_roll
      categories.each do |category, range|
        when range
          @prize_category = category
          self.level
      end
      else
        false
    end
  end

  def level
    case reward_level
      reward_level_for_"#{prize_category}".each do |rarity, range|
        when range
          Ability

      end


  end







