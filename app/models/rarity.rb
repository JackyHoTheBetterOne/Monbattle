class Rarity < ActiveRecord::Base
  has_many :monsters
  has_many :abilities

  validates :name, presence: {message: 'Must be entered'}

end
