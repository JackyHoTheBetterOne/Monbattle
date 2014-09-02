class MonsterTemplate < ActiveRecord::Base

  belongs_to :element_template
  belongs_to :class_template
  has_many :monsters

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :max_hp, presence: {message: 'Must be entered'}
  validates :max_sp, presence: {message: 'Must be entered'}
  validates :max_lvl, presence: {message: 'Must be entered'}
  validates :class_template_id, presence: {message: 'Must be entered'}
  validates :element_template_id, presence: {message: 'Must be entered'}
  
end
