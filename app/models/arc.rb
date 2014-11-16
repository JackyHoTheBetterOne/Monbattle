class Arc < ActiveRecord::Base
  has_many :chapters

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
end