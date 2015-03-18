class BattleLevel < ActiveRecord::Base
  has_many :battles
  belongs_to :area
  belongs_to :unlocked_by, class_name: "BattleLevel"

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :stamina_cost, presence: true

  has_many :cut_scenes, dependent: :destroy
  has_many :monster_assignments
  has_many :monsters, through: :monster_assignments

  after_destroy :delete_party
  before_save :set_keywords

  scope :search, -> (keyword) {
    if keyword.present?
      where("keywords LIKE ?", "%#{keyword.downcase}%")
    end
  }

  scope :filter, -> (filter) {
    if filter.present?
      joins(:area).where("areas.name = ?", "#{filter}")
    end
  }

  def start_cut_scenes
    array = []
    self.cut_scenes.where("cut_scenes.to_start is true AND cut_scenes.defeat is false").
      order("cut_scenes.order ASC").each do |c|
        array << c.image.url(:cool)
    end
    return array
  end

  def end_cut_scenes
    array = []
    self.cut_scenes.where("cut_scenes.to_start is false AND cut_scenes.defeat is false").
      order("cut_scenes.order ASC").each do |c|
        array << c.image.url(:cool)
    end
    return array
  end


  def defeat_cut_scenes
    array = []
    self.cut_scenes.where("cut_scenes.defeat is true").
      order("cut_scenes.order ASC").each do |c|
        array << c.image.url(:cool)
    end
    return array
  end


  def area_name
    if self.area
      self.area.name
    else
      ""
    end
  end

  def region_name
    if self.area
      if self.area.region
        self.area.region.name
      else
        ""
      end
    else
      ""
    end
  end

  def self.unlocked_levels(beaten_levels)
    available_levels = []
    if self != []
      self.all.each do |b|
        if b.unlocked_by
          available_levels << BattleLevel.find(b.id) if beaten_levels.include?b.unlocked_by.name
        else
          available_levels << b 
        end
      end
    end
    return available_levels
  end

  def ability_given
    if self.ability_reward.length == 0
      ""
    elsif self.ability_reward[0] != "ability" && self.ability_reward[0] != "monster"
      self.ability_reward[0] + ": " + self.ability_reward[1]
    else
      self.ability_reward[1]
    end
  end

  def reward
    if self.ability_reward.length == 0
      "NOTHING"
    elsif self.ability_reward[0] == "Monster" || self.ability_reward[0] == "Ability"
      self.ability_reward[1] 
    elsif self.ability_reward.length == 2
      self.ability_reward[1] + ": " + self.ability_reward[0]
    end
  end

  def first_clear_reward
    if self.ability_reward.length == 2
      if self.ability_reward[0] == "monster" || self.ability_reward[0] == "ability"
        return self.ability_reward[1]
      else
        return "x " + self.ability_reward[1]
      end
    end

  end

  def first_clear_reward_image
    if self.ability_reward.length != 0
      case self.ability_reward[0]
        when "monster"
          return Monster.find_by_name(self.ability_reward[1]).default_skin_img
        when "ability"
          return Ability.find_by_name(self.ability_reward[1]).portrait
        when "gp"
          return "https://s3-us-west-2.amazonaws.com/monbattle/images/gp.png"
        when "mp"
          return "https://s3-us-west-2.amazonaws.com/monbattle/images/mp.png"
        when "enh"
          return "https://s3-us-west-2.amazonaws.com/monbattle/images/enhance.png"
        when "asp"
          return "https://s3-us-west-2.amazonaws.com/monbattle/images/ascend.png"
      end
    else
      return ""
    end

  end

  def second_clear_reward_image
    if self.time_reward[0] == "mp" 
      return "https://s3-us-west-2.amazonaws.com/monbattle/images/mp.png"
    elsif self.time_reward[0] == "gp" 
      return "https://s3-us-west-2.amazonaws.com/monbattle/images/gp.png"
    elsif self.time_reward[0] == "asp" 
      return "https://s3-us-west-2.amazonaws.com/monbattle/images/ascend.png"
    elsif self.time_reward[0] == "enh" 
      return "https://s3-us-west-2.amazonaws.com/monbattle/images/enhance.png"
    elsif self.time_reward[0] == "ability"
      return Ability.find_by_name(self.time_reward[1]).portrait
    end
  end


  def pity_reward_image
    if self.pity_reward[0] == "mp" 
      return "https://s3-us-west-2.amazonaws.com/monbattle/images/mp.png"
    elsif self.pity_reward[0] == "gp" 
      return "https://s3-us-west-2.amazonaws.com/monbattle/images/gp.png"
    elsif self.pity_reward[0] == "asp" 
      return "https://s3-us-west-2.amazonaws.com/monbattle/images/ascend.png"
    elsif self.pity_reward[0] == "enh" 
      return "https://s3-us-west-2.amazonaws.com/monbattle/images/enhance.png"
    end
  end

############################################################################# General method

  def has_cut_scene
    if self.start_cut_scenes.length == 0 && self.end_cut_scenes.length == 0
      return false
    else
      return true
    end 
  end

  def is_currency_reward
    if self.ability_reward.length != 0
      if self.ability_reward[0] == "monster" || self.ability_reward[0] == "ability"
        return false
      else
        return true
      end
    else
      return false
    end
  end

  private
  def delete_party
    Party.where("user_id = 2").where(name: self.name).destroy_all
  end

  def set_keywords
    self.keywords = [self.name, self.area_name, self.region_name, 
                     self.ability_given].map(&:downcase).
                     concat([time_requirement]).join(" ")
  end
end
