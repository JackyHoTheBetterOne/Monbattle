class Notice < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true
  validates :body, presence: true, uniqueness: true
  validates :notice_type_id, presence: true
  belongs_to :notice_type

  def category
    self.notice_type.name
  end
end
