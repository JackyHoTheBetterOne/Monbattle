class Target < ActiveRecord::Base

  has_many :effects
  
  validates :name, presence: {message: 'Must be entered'}, uniqueness: true

end
