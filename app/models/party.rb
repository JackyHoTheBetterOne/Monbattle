class Party < ActiveRecord::Base
  belongs_to :user

  has_many :members, dependent: :destroy
  has_many :monsters, through: :members
end
