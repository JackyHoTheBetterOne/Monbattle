class Party < ActiveRecord::Base
  belongs_to :user

  has_many :fights, dependent: :destroy
  has_many :battles, through: :fights
  has_many :members, dependent: :destroy
  has_many :monsters, through: :members

  validates :user_id, presence: {message: 'Must be entered'}
                                 # uniqueness: true unless: :{ |c| !c.logged_in? }

  validates :name, presence: {message: "Must be entered"},
                              uniqueness: {scope: :user_id}

  before_save :npcCheck

  # def count_party_members(user_id)
  #   find_by_user_id(user_id).members.count
  # end

  def self.members_count_for(user)
    find_by_user_id(user).members.count
  end

  def username
    self.user.user_name
  end

  def isNPC
    self.user.user_name && "NPC"
  end

  def mon_dex(mon)
    self.monsters.index(mon)
  end

  def as_json(options={})

    super(
      :only => [:user_id, :name],
      :methods => [:username, :isNPC],
      :include => { :monsters => {
        :only => [:id, :name, :max_hp, :hp => :max_hp],
        :methods => :hp,
        :include => { :abilities => {
          :only => [:id, :name, :ap_cost, :stat_change],
          :methods => [:stat, :targeta, :elementa, :change, :modifier],
          :include => {
            :effects => {
              :only => [:id, :name, :stat_change],
              :methods => [:stat, :targeta, :change, :modifier],
            }
          }
        }}
      }}
    )
  end

  protected
  def npcCheck
    if self.username == "NPC"
      self.npc = true
    else
      self.npc = false
    end
  end


end
