class Chapter < ActiveRecord::Base
  has_many :cut_scenes
  belongs_to :arc

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
end