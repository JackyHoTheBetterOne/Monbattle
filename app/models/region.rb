class Region < ActiveRecord::Base
  has_many :areas, dependent: :destroy
  belongs_to :unlocked_by, class_name: "Region"

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
        if r.unlocked_by
          available_regions << Region.find(r.id) if beaten_regions.include?r.unlocked_by.name
        else
          available_regions << r
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
