class Effect < ActiveRecord::Base

  belongs_to :element
  belongs_to :target
  belongs_to :stat_target
  has_many :ability_effects, dependent: :destroy
  has_many :abilities, through: :ability_effects

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :stat_change, presence: {message: 'Must be entered'}
  validates :target_id, presence: {message: 'Must be entered'}
  validates :stat_target_id, presence: {message: 'Must be entered'}
  validates :element_id, presence: {message: 'Must be entered'}

  before_save :set_keywords


  has_attached_file :icon, :styles => { :cool => "40x40>", :thumb => "100x100>" }

  validates_attachment_content_type :icon, :content_type => /\Aimage\/.*\Z/

  def stat
    self.stat_target.name.downcase
  end

  def targeta
    self.target.name.downcase
  end

  def elementa
    self.element.name.downcase
  end

  def modifier
    self.stat_change[0,1]
  end

  def change
    self.stat_change.split("").drop(1).join("")
  end

  private
  def set_keywords
    self.keywords = [name, stat_change, self.targeta, self.element.name].map(&:downcase).join(" ")
  end
end
