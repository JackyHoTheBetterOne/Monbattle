class Guild < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :leader_id, presence: true

  belongs_to :leader, class_name: "Summoner", foreign_key: "leader_id"
  has_many :members, class_name: "Summoner", foreign_key: "guild_id"
  has_many :sub_leaders, class_name: "Summoner", foreign_key: "sub_led_guild_id"
  has_many :guild_messages

  has_many :notifications, as: :notificapable, dependent: :destroy
  has_many :scores, as: :scorapable, dependent: :destroy

  before_save :set_keywords

  scope :general_search, -> (keyword, level) {
    if keyword.present?
      where("keywords LIKE ?", "%#{keyword.downcase}%").
        where("minimum_level <= #{level}")
    else
      where("minimum_level <= #{level}")
    end
  }

  scope :score_search, -> (area_id, guild_id) {
    joins(:scores).where("scores.area_id = #{area_id} AND scores.scorapable_type = 'Guild' AND scores.scorapable_id = #{guild_id}").
      order("scores.points DESC").pluck(:id)
  }


  def self.check_name_uniqueness(name)
    where(name: name).present?
  end


  protected
  def set_keywords
    self.keywords = [self.name, self.description].map(&:downcase).join(" ")
  end

end
