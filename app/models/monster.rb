class Monster < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :job
  belongs_to :element
  belongs_to :monster_skin

  has_many :ability_equippings, dependent: :destroy
  has_many :equipped_abilities, through: :ability_equippings, source: :ability
  has_many :evolved_states, dependent: :destroy

  validates :name, presence: {message: 'Must be entered'}
  validates :max_hp, presence: {message: 'Must be entered'}
  validates :user_id, presence: {message: 'Must be entered'}
  validates :element_id, presence: {message: 'Must be entered'}
  validates :job_id, presence: {message: 'Must be entered'}

end
