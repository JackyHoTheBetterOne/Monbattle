class EvolvedState < ActiveRecord::Base


  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :job_id, presence: {message: 'Must be entered'}
  validates :element_id, presence: {message: 'Must be entered'}
  validates :evolve_lvl, presence: {message: 'Must be entered'}
  validates :created_from_id, presence: {message: 'Must be entered'}
  validates :monster_id, presence: {message: 'Must be entered'}
  validates :is_template, presence: {message: 'Must be entered'}
  validates :hp_modifier, presence: {message: 'Must be entered'}
  validates :dmg_modifier, presence: {message: 'Must be entered'}

end
