class Quest < ActiveRecord::Base
  belongs_to :quest_type
  belongs_to :reward_category

  validates :name, presence: {message: 'Must be entered'}
  validates :quest_type_id, presence: true
  validates :reward_category_id, presence: true

  before_save :set_keywords

  has_attached_file :icon,
                  styles: { medium: "300 x 300>",
                            small: "150x150>",
                            thumb: "100 x 100>",
                            tiny: "50 x 50>"}

  validates_attachment_content_type :icon, :content_type => /\Aimage\/.*\Z/

  scope :search, -> (keyword) {
    if keyword.present?
      where("keywords LIKE ?", "%#{keyword.downcase}%")
    end
  }

  def type
    self.quest_type.name
  end

  def reward
    self.reward_category.name
  end

  private

  def set_keywords
    self.keywords = [name, description, self.type, self.reward].map(&:downcase).
                      concat([reward_amount, requirement, stat, bonus, stat_requirement]).join(" ")

  end

end
