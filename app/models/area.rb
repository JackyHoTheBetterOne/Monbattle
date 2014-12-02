class Area < ActiveRecord::Base
  has_many :battle_levels
  belongs_to :unlock, class_name: "Area"
  belongs_to :region

  before_save :set_keywords
  validates :name, presence: true

  scope :filter, -> (filter) {
    if filter.present?
      joins(:region).where("regions.name = ?", "#{filter}")
    end
  }


  def region_name
    self.region.name
  end

  private

  def set_keywords
    self.keywords = [name, self.region_name].map(&:downcase).join(" ")
  end

end
