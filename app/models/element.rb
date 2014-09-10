class Element < ActiveRecord::Base
  has_many :monsters
  has_many :effects
  
  before_save :capitalize_name

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true

  private

  def capitalize_name
    self.name.capitalize!
  end
end
