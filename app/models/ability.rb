class Ability < ActiveRecord::Base

  belongs_to :class_template
  has_many :ability_effects, dependent: :destroy
  has_many :effects, through: :ability_effects
  has_many :ability_equippings, dependent: :destroy

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :ap_cost, presence: {message: 'Must be entered'}
  validates :description, presence: {message: 'Must be entered'}
  validates :min_level, presence: {message: 'Must be entered'}
  validates :class_template_id, presence: {message: 'Must be entered'}

end
