class Job < ActiveRecord::Base
  
  has_many :monsters
  has_many :abilities
  has_many :monster_skins

  before_save :capitalize_name

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :evolve_lvl, presence: {message: 'Must be entered'}
  
  private

  def capitalize_name
    self.name.capitalize!
  end
end
