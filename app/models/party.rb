class Party < ActiveRecord::Base
  belongs_to :user

  has_many :members, dependent: :destroy
  has_many :monsters, through: :members

  validates :user_id, presence: {message: 'Must be entered'}, uniqueness: true
  validates :name, presence: {message: 'Must be entered'}
end
