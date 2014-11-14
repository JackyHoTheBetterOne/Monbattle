class Party < ActiveRecord::Base
  belongs_to :user

  has_many :fights, dependent: :destroy
  has_many :battles, through: :fights
  has_many :members, dependent: :destroy
  has_many :monster_unlocks, through: :members
  has_many :mons, through: :members, source: :monster_unlock
  has_many :monsters, through: :mons
  has_many :monster_unlocks, through: :members

  validates :user_id, presence: {message: 'Must be entered'}
                                 # uniqueness: true unless: :{ |c| !c.logged_in? }

  validates :name, presence: {message: "Must be entered"}

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
      :only => [:name],
      :methods => [:username, :isNPC],
      :include => {
        :mons => {
          :only => [],
          :methods => [:name, :max_hp, :hp,:speech, :mon_evols],
          :include => {
            :abilities => {
              :only => [:name, :ap_cost, :stat_change, :description],
              :methods => [:stat, :targeta, :elementa, :change, :modifier, :img, :slot],
              :include => {
                :effects => {
                  :only => [:name, :stat_change, :restore, :duration, :description],
                  :methods => [:stat, :targeta, :change, :modifier, :img],
                }
              }
            }
          }
        }
      }
    )
  end

  def self.generate(user)
    BattleLevel.all.each do |level|
      Party.where("user_id = 2").where(name: level.name).where(enemy: user.user_name).destroy_all
      party = Party.create!(
        user_id: 2,
        name: level.name,
        enemy: user.user_name
        )
      npc_mons = MonsterUnlock.where("user_id = 2")
      party.mons = npc_mons.shuffle[0..3]
      party.save
    end
  end

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
