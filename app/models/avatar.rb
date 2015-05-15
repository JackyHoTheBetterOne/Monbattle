class Avatar < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many :summoners
end
