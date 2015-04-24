class Area < ActiveRecord::Base
  has_many :battle_levels
  belongs_to :unlocked_by, class_name: "Area"
  belongs_to :region

  before_save :set_keywords
  validates :name, presence: true, uniqueness: true

  has_many :scores

  scope :filter, -> (filter) {
    if filter.present?
      joins(:region).where("regions.name = ?", "#{filter}")
    end
  }


  def self.event_areas
    @areas = Area.where("start_date IS NOT NULL AND is_guild IS FALSE").order(:end_date)
    @events = []

    @areas.each do |a|
      @events << a if a.end_date >= Time.now && a.start_date <= Time.now
    end

    return @events
  end

  def self.gbattle_areas
    @areas = Area.where("start_date IS NOT NULL AND is_guild IS TRUE").order(:end_date)
    @events = []

    @areas.each do |a|
      @events << a if a.end_date >= Time.now && a.start_date <= Time.now
    end

    return @events
  end




############################################################################################### Decorating

  def region_name
    if self.region
      self.region.name
    else
      ""
    end
  end

  def unlock
    if unlocked_by
      Area.find(self.unlocked_by).name
    else
      ""
    end
  end

  def time_left
    if self.start_date
      date = {}
      general_days = (self.end_date - Time.now)/60/60/24
      days = general_days.floor
      true_hours = ((general_days - days)*24)
      hours = true_hours.floor
      minutes = ((true_hours - hours)*60).floor

      date["days"] = days
      date["hours"] = hours
      date["minutes"] = minutes

      sentence = ""

      sentence += (date["days"].to_s + " d") if date["days"] != 0
      sentence += (" " + date["hours"].to_s + " h")
      sentence += (" " + date["minutes"].to_s + " m left")

      return sentence
    else
      return ""
    end
  end

  def self.unlocked_areas(beaten_areas)
    available_areas = []
    if self != []
      self.all.each do |a|
        if a.unlocked_by
          available_areas << Area.find(a.id) if beaten_areas.include?a.unlocked_by.name
        else
          available_areas << a
        end
      end
    end
    return available_areas
  end

###########################################################################################################


  private

  def set_keywords
    self.keywords = [name, self.region_name].map(&:downcase).join(" ")
  end

end
