class Ability < ActiveRecord::Base

  belongs_to :job
  has_many :ability_purchases, dependent: :destroy
  has_many :users, through: :ability_purchases
  has_many :ability_effects, dependent: :destroy
  has_many :effects, through: :ability_effects
  has_many :ability_equippings, dependent: :destroy
  has_many :monsters, through: :ability_equippings
  has_many :evolved_ability_equippings, dependent: :destroy
  has_many :evolved_states, through: :evolved_ability_equippings


  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :ap_cost, presence: {message: 'Must be entered'}
  validates :description, presence: {message: 'Must be entered'}
  validates :min_level, presence: {message: 'Must be entered'}
  validates :job_id, presence: {message: 'Must be entered'}
  
  private

  def capitalize_name
    self.name.capitalize!
  end
end
