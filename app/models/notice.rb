class Notice < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true
  validates :body, presence: true, uniqueness: true
  validates :notice_type_id, presence: true
  belongs_to :notice_type

  before_save :set_keywords

  has_attached_file :banner, 
                    styles: {thumb: "100 x 100>", cool: "960 x 240>"}
  has_attached_file :description_image, 
                    styles: {thumb: "100 x 100>", cool: "525 x 255>"}

  scope :search, -> (keyword) {
    if keyword.present?
      where("keywords LIKE ?", "%#{keyword.downcase}%")
    end
  }

  def category
    self.notice_type.name
  end

  private

  def set_keywords
    self.keywords = [title, body, self.category].map(&:downcase).join(" ")
  end

end
