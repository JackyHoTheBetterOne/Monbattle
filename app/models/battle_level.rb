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
    self.cut_scenes.where("cut_scenes.to_start is true").order("cut_scenes.order ASC").each do |c|
      array << c.image.url(:cool)
    end
    return array
  end

  def end_cut_scenes
    array = []
    self.cut_scenes.where("cut_scenes.to_start is false").order("cut_scenes.order ASC").each do |c|
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
      end
    else
      return ""
    end

  end

  def second_clear_reward_image
    if self.mp_reward != 0 
      return "https://s3-us-west-2.amazonaws.com/monbattle/images/mp.png"
    elsif self.gp_reward != 0
      return "https://s3-us-west-2.amazonaws.com/monbattle/images/mp.png"
    elsif self.asp_reward != 0
      return "https://s3-us-west-2.amazonaws.com/monbattle/images/ascend.png"
    elsif self.enh_reward != 0 
      return "https://s3-us-west-2.amazonaws.com/monbattle/images/enhance.png"
    end
  end

  def second_clear_reward
    if self.gp_reward != 0 
      return self.gp_reward
    elsif self.mp_reward != 0
      return self.mp_reward
    elsif self.asp_reward != 0
      return self.asp_reward
    elsif self.enh_reward != 0 
      return self.enh_reward
    end
  end



############################################################################ Unlock level, area or region
  def unlock_for_summoner(summoner, round_taken, battle)
    @summoner = Summoner.find_by_name(summoner)
    @user = @summoner.user
    @battle = Battle.find(battle)

    ability_reward_array = self.ability_reward
    level_name = self.name
    cleared_twice_level_array = @summoner.cleared_twice_levels.dup


    if @summoner.name != "NPC"
      if @summoner.beaten_levels.include?(level_name) && !cleared_twice_level_array.include?(level_name) 
        cleared_twice_level_array.push(level_name) 
      end
      if !@summoner.beaten_levels.include?(level_name) && ability_reward_array.length != 0 &&
          !cleared_twice_level_array.include?(level_name) 
        if ability_reward_array[0] == "ability"
          ability = Ability.find_by_name(ability_reward_array[1])
          ability_id = ability.id 
          user_id = @summoner.user.id
          AbilityPurchase.create!(ability_id: ability_id, user_id: user_id)
        elsif ability_reward_array[0] == "monster"
          monster = Monster.find_by_name(ability_reward_array[1])
          monster_id = monster.id 
          user_id = @summoner.user.id
          if MonsterUnlock.where(monster_id: monster_id, user_id: user_id).length == 0
            MonsterUnlock.create!(monster_id: monster_id, user_id: user_id) 
          end
        elsif ability_reward_array.length == 2
          @summoner[ability_reward_array[0]] += ability_reward_array[1].to_i
        end
      end

      level_array = @summoner.beaten_levels.dup
      area_array = @summoner.completed_areas.dup
      region_array = @summoner.completed_regions.dup

      if !level_array.include?self.name
        level_array.push(self.name) 
        @battle.track_progress(@user.id)
        unlocked_level = BattleLevel.where(unlocked_by_id: self.id)[0]
        if unlocked_level
          @summoner.recently_unlocked_level = unlocked_level.name 
          @summoner.latest_level = unlocked_level.name.gsub(" ","")
        end
      end

      if !area_array.include?self.area.name
        area_cleared = 0
        self.area.battle_levels.each do |b|
          if !level_array.include?b.name
            area_cleared = false
          end
        end

        if area_cleared != false
          area_array.push(self.area.name)
          latest_level_name = Area.find_by_unlocked_by_id(self.area.id).battle_levels.
            first.name.gsub(" ", "") if Area.find_by_unlocked_by_id(self.area.id)
          @summoner.latest_level = latest_level_name
        end
      end

      if !region_array.include?self.area.region.name
        region_cleared = 0
        self.area.region.areas.each do |a|
          if !area_array.include?a.name
            region_cleared = false
          end
        end

        if region_cleared != false
          region_array.push(self.area.region.name)
          latest_level_name = Region.find_by_unlocked_by_id(1).areas.first.battle_levels.
            first.name.gsub(" ", "") if Region.find_by_unlocked_by_id(self.area.region.id)
          @summoner.latest_level = latest_level_name
        end
      end

      @summoner.cleared_twice_levels = cleared_twice_level_array
      @summoner.beaten_levels = level_array
      @summoner.completed_areas = area_array
      @summoner.completed_regions = region_array
      @summoner.save
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
