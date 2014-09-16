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

  def username
    self.user.user_name
  end

  def as_json(options={})

    super(
      :only => [:user_id, :name],
      :methods => :username,
      :include => { :monsters => {
        :only => [:id, :name, :max_hp, :hp => :max_hp],
        :methods => :hp,
        :include => { :abilities => {
          :only => [:id, :name, :ap_cost, :state_change],
          :methods => [:stat_targeta, :targeta, :elementa],
          :include => { 
            :effects => {
              :only => [:id, :name, :stat_change],
              :methods => [],
            }
          }
        }}
      }}
    )

  end

end
