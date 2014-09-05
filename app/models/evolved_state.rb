class EvolvedState < ActiveRecord::Base
  belongs_to :job
  belongs_to :element
  belongs_to :monster_skin_id
  belongs_to :monster
  has_many :evolved_ability_equippings, dependent: :destroy
  has_many :abilites, through: :evolved_ability_equippings

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :job_id, presence: {message: 'Must be entered'}
  validates :element_id, presence: {message: 'Must be entered'}
  validates :evolve_lvl, presence: {message: 'Must be entered'}

end
