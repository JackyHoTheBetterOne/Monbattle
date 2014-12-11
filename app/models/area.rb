class Area < ActiveRecord::Base
  has_many :battle_levels
  belongs_to :unlock, class_name: "Area"
  belongs_to :region

  before_save :set_keywords
  validates :name, presence: true, uniqueness: true

  scope :filter, -> (filter) {
    if filter.present?
      joins(:region).where("regions.name = ?", "#{filter}")
    end
  }

  def region_name
    self.region.name
  end

  def self.unlocked_areas(beaten_areas)
    available_areas = []
    if self != []
      self.all.each do |a|
        available_areas << a if a.unlocked_by_default == true
        if a.unlock
          available_areas << Area.find(a.unlock.id) if beaten_areas.include?a.name
        end
      end
    end
    return available_areas
  end

  private

  def set_keywords
    self.keywords = [name, self.region_name].map(&:downcase).join(" ")
  end

end
