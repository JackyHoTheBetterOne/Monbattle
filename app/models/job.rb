class Job < ActiveRecord::Base
  
  has_many :evolved_states
  has_many :monsters
  has_many :abilities 

  before_save :capitalize_name

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :evolve_lvl, presence: {message: 'Must be entered'}
  
  private

  def capitalize_name
    self.name.capitalize!
  end
end
