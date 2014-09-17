class Ability < ActiveRecord::Base

  belongs_to :job
  belongs_to :target
  belongs_to :stat_target
  belongs_to :element

  has_many :ability_purchases, dependent: :destroy
  has_many :ability_purchased_users, through: :ability_purchases, source: :user
  has_many :ability_effects, dependent: :destroy
  has_many :effects, through: :ability_effects

  has_many :ability_equippings, dependent: :destroy
  has_many :equipped_monsters, through: :ability_equippings, source: :monster
  has_many :equipped_users, through: :ability_equippings, source: :user

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :ap_cost, presence: {message: 'Must be entered'}
  validates :description, presence: {message: 'Must be entered'}
  validates :min_level, presence: {message: 'Must be entered'}
  validates :job_id, presence: {message: 'Must be entered'}
  validates :target_id, presence: {message: 'Must be entered'}
  validates :stat_target_id, presence: {message: 'Must be entered'}
  validates :element_id, presence: {message: 'Must be entered'}
  validates :stat_change, presence: {message: 'Must be entered'}

  private

  def capitalize_name
    self.name.capitalize!
  end
end
