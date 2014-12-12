class Region < ActiveRecord::Base
  has_many :areas, dependent: :destroy
  belongs_to :unlock, class_name: "Region"

  validates :name, presence: true, uniqueness: true

  accepts_nested_attributes_for :areas, :allow_destroy => true, :reject_if => lambda { |a| a[:name].blank? }

  has_attached_file :map, :styles => { :cool => "600x400>", :thumb => "100x100>" }
  validates_attachment_content_type :map, :content_type => /\Aimage\/.*\Z/

  scope :search, -> (keyword) {
    if keyword.present?
      where("keywords LIKE ?", "%#{keyword.downcase}%")
    end
  }

  before_save :set_keywords

  def as_json(options={})
    super(
      :methods => :icon,
      )
  end

  def icon
    self.map.url(:thumb)
  end


  def self.unlocked_regions(beaten_regions)
    available_regions = []
    if self != []
      self.all.each do |r|
        available_regions << r if r.unlocked_by_default == true
        if r.unlock
          available_regions << Region.find(r.unlock.id) if beaten_regions.include?r.name
        end
      end
    end
    return available_regions
  end

  private
  def set_keywords
    area_names = []
    self.areas.each do |a|
      area_names << a.name.downcase
    end
    area_names << self.name.downcase
    self.keywords = area_names.join(" ")
  end
end
