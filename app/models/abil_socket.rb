class AbilSocket < ActiveRecord::Base
  has_many :abilities

  validates :socket_num, presence: {message: 'Must be entered'},
                         uniqueness: true,
                         numericality: { only_integer: true }
end
