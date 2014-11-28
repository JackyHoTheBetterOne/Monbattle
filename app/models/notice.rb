class Notice < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true
  validates :body, presence: true, uniqueness: true
  validates :notice_type_id, presence: true
  belongs_to :notice_type

  before_save :set_keywords

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
