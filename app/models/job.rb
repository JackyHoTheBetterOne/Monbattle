class Job < ActiveRecord::Base

  has_many :monsters
  has_many :ability_restrictions
  has_many :abilities, through: :ability_restrictions
  has_many :skin_restrictions, dependent: :destroy
  has_many :monster_skins, through: :skin_restrictions

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :evolve_lvl, presence: {message: 'Must be entered'}
  validates :evolve_lvl, numericality: true

  scope :alphabetical, -> { order("lower(name)") }

end
