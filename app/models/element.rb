class Element < ActiveRecord::Base
  has_many :monsters
  has_many :effects
  has_many :abilities

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true

  scope :alphabetical, -> { order("lower(name)") }

end
