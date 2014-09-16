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

end
