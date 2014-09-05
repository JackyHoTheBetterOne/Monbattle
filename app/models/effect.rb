class Effect < ActiveRecord::Base
  
  belongs_to :element
  belongs_to :target
  has_many :ability_effects, dependent: :destroy
  has_many :abilities, through: :ability_effects

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :damage, presence: {message: 'Must be entered'}
  validates :target, presence: {message: 'Must be entered'}
  validates :modifier, presence: {message: 'Must be entered'}

end
