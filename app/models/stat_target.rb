class StatTarget < ActiveRecord::Base
  has_many :effects
  has_many :abilities

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
end