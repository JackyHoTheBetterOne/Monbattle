class Element < ActiveRecord::Base
  has_many :monsters
  has_many :effects
  has_many :abilities

  before_save :capitalize_name

  validates :name, presence: {message: 'Must be entered'}, uniqueness: true

  private

  def capitalize_name
    self.name.capitalize!
  end
end
