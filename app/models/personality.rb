class Personality < ActiveRecord::Base
  has_many :monsters
  has_many :thoughts, dependent: :destroy

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true

end
