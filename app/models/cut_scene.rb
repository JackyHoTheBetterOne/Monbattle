class CutScene < ActiveRecord::Base
  belongs_to :chapter
  belongs_to :battle_level
  validates :name, presence: {message: 'Must be entered'}, uniqueness: true

  has_attached_file :image, :styles => { :cool => "960x600>", :thumb => "100x100>"}
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  before_save set_keywords

  def chapter_name
    self.chapter.name if self.chapter
  end

  def arc_name
    self.chapter.arc.name if self.chapter.arc
  end



  private

  def set_keywords
    self.keywords = [name, description, self.chapter_name, self.arc_name].map(&:downcase).
                    concat([order]).join(" ")
  end


end