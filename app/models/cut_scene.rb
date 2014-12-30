class CutScene < ActiveRecord::Base
  belongs_to :chapter
  belongs_to :battle_level
  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :chapter_id, presence: true

  has_attached_file :image, :styles => { :cool => "960x600>", :thumb => "100x100>"}
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  scope :search, -> (keyword) {
    if keyword.present?
      where("keywords LIKE ?", "%#{keyword.downcase}%")
    end
  }

  before_save :set_keywords

  def chapter_name
    if self.chapter
      self.chapter.name 
    else
      ""
    end
  end

  def arc_name
    if self.chapter.arc
      self.chapter.arc.name 
    else 
      ""
    end
  end

  def level_name
    if self.battle_level
      self.battle_level.name
    else
      ""
    end
  end

  private

  def set_keywords
    self.keywords = [name, description, to_start.to_s, self.chapter_name, self.arc_name].map(&:downcase).
                    concat([order]).join(" ")
  end


end