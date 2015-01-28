class Target < ActiveRecord::Base
  has_many :effects
  has_many :abilities

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true

  scope :alphabetical, -> { order('name') }

  belongs_to :target_category

  scope :effect, -> () {
    joins(:target_category).where("target_categories.name = 'effect'")
  }

  scope :ability, -> () {
    joins(:target_category).where("target_categories.name = 'ability'")
  }
end
