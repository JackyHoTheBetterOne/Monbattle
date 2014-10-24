class AbilSocket < ActiveRecord::Base
  has_many :abilities

  validates :socket_num, presence: {message: 'Must be entered'},
                         uniqueness: true,
                         numericality: { only_integer: true }

  def self.socket(socket_num)
    self.find_by_socket_num(socket_num)
  end

  def self.socket_id(socket_num)
    self.find_by_socket_num(socket_num).id
  end

end
