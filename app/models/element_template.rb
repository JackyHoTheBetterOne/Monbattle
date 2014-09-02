class ElementTemplate < ActiveRecord::Base

  has_many :monster_templates
  has_many :monsters, through: :monster_templates
  has_many :effects
  
  before_save :capitalize_name

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true

  private

  def capitalize_name
    self.name.capitalize!
  end
    
end
