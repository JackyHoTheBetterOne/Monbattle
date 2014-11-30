class BattleLevel < ActiveRecord::Base
  has_many :battles
  belongs_to :area
  belongs_to :unlock, class_name: "BattleLevel"

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true

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

  def self.unlocked_levels(summoner)
    available_levels = []
    BattleLevel.all.each do |b|
      if b.unlock == nil
        available_levels << b 
      else 
        available_levels << b if summoner.include?b.unlock.name 
      end
    end
    return available_levels
  end
  
  private
  def delete_party
    Party.where("user_id = 2").where(name: self.name).destroy_all
  end

  def set_keywords
    self.keywords = [name, self.area_name, self.region_name].map(&:downcase).join(" ")
  end
end
