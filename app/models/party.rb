class Party < ActiveRecord::Base
  belongs_to :user

  has_many :fights, dependent: :destroy
  has_many :battles, through: :fights
  has_many :members, dependent: :destroy
  has_many :mons, through: :members, source: :monster_unlock
  has_many :monsters, through: :mons

  validates :user_id, presence: {message: 'Must be entered'}
                                 # uniqueness: true unless: :{ |c| !c.logged_in? }

  validates :name, presence: {message: "Must be entered"},
                              uniqueness: {scope: :user_id}

  before_save :npcCheck
  default_scope { order("npc") }

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

  # def mon_dex(mon)
  #   self.monsters.index(mon)
  # end
  def mon_dex(mon)
    self.mons.index(mon)
  end

  def as_json(options={})
    super(
      :only => [:user_id, :name],
      :methods => [:username, :isNPC],
      :include => {
        :mons => {
          :only => [],
          :methods => [:name, :max_hp, :hp, :mon_evols],
          :include => {
            :abilities => {
              :only => [:name, :ap_cost, :stat_change, :description],
              :methods => [:stat, :targeta, :elementa, :change, :modifier, :img, :slot],
              :include => {
                :effects => {
                  :only => [:name, :stat_change],
                  :methods => [:stat, :targeta, :change, :modifier],
                }
              }
            }
          }
        }
      }
    )
  end

  #   def as_json(options={})

  #   super(
  #     :only => [:user_id, :name],
  #     :methods => [:username, :isNPC],
  #     :include => { :monsters => {
  #       :only => [:id, :name, :max_hp, :hp => :max_hp],
  #       :methods => :hp,
  #       :include => { :abilities => {
  #         :only => [:id, :name, :ap_cost, :stat_change],
  #         :methods => [:stat, :targeta, :elementa, :change, :modifier, :img, :slot],
  #         :include => {
  #           :effects => {
  #             :only => [:id, :name, :stat_change],
  #             :methods => [:stat, :targeta, :change, :modifier],
  #           }
  #         }
  #       }}
  #     }}
  #   )
  # end

  protected
  def npcCheck
    if self.username == "NPC"
      self.npc = true
    else
      self.npc = false
      return true
    end
  end

end
