class BattleLevel < ActiveRecord::Base
  has_many :battles
  belongs_to :area
  belongs_to :unlocked_by, class_name: "BattleLevel"

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :stamina_cost, presence: true

  has_attached_file :background, :styles => { :cool => "960x600>", :thumb => "100x100>" }
  validates_attachment_content_type :background, :content_type => /\Aimage\/.*\Z/

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

############################################################################ Unlock level, area or region
  def unlock_for_summoner(summoner)
    @summoner = Summoner.find(summoner.id)
    level_array = @summoner.beaten_levels.clone
    area_array = @summoner.completed_areas.clone
    region_array = @summoner.completed_regions.clone

    if !level_array.include?self.name
      level_array.push(self.name) 
      unlocked_level = BattleLevel.where(unlocked_by_id: self.id)[0]
      @summoner.recently_unlocked_level = unlocked_level.name if unlocked_level
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
      end
    end

    @summoner.beaten_levels = level_array
    @summoner.completed_areas = area_array
    @summoner.completed_regions = region_array
    @summoner.save
  end

#############################################################################

  private
  def delete_party
    Party.where("user_id = 2").where(name: self.name).destroy_all
  end

  def set_keywords
    self.keywords = [name, self.area_name, self.region_name].map(&:downcase).join(" ")
  end
end
