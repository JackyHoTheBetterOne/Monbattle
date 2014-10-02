class BattleLevel < ActiveRecord::Base
  has_many :battles

  has_one :background

  validates :name, presence: {message: 'Must be entered'}, uniqueness: :true
end
