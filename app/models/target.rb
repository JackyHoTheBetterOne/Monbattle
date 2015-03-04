class Target < ActiveRecord::Base
  has_many :effects
  has_many :abilities

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true

  scope :alphabetical, -> { order('name') }

  has_many :target_categories
  has_many :target_types, through: :target_categories

  scope :effect, -> () {
    joins(:target_types).where("target_types.name = 'Effect'")
  }

  scope :ability, -> () {
    joins(:target_types).where("target_types.name = 'Ability'")
  }
end
