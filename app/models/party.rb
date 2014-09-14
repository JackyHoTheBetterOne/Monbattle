class Party < ActiveRecord::Base
  belongs_to :user

  has_many :members, dependent: :destroy
  has_many :monsters, through: :members

  validates :user_id, presence: {message: 'Must be entered'}, uniqueness: true
  validates :name, presence: {message: "Must be entered"},
                  uniqueness: {scope: :user_id}

  # def count_party_members(user_id)
  #   find_by_user_id(user_id).members.count
  # end

  def self.members_count_for(user)
    find_by_user_id(user).members.count
  end

end
