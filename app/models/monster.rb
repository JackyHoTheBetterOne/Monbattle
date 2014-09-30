class Monster < ActiveRecord::Base

  belongs_to :job
  belongs_to :element

  has_many :evolutions, class_name: "Monster",
                        foreign_key: "evolved_from_id"
  belongs_to :evolved_from, class_name: "Monster"

  has_many :monster_skin_equippings, dependent: :destroy
  has_many :monster_skin_equipped_skins, through: :monster_skin_equippings, source: :monster_skin
  has_many :monster_skin_equipped_users, through: :monster_skin_equippings, source: :user

  has_many :ability_equippings, through: :monster_unlocks
  has_many :abilities, through: :monster_unlocks
  has_many :monster_unlocks, dependent: :destroy
  has_many :monster_unlocked_users, through: :monster_unlocks, source: :user
  has_many :members, through: :monster_unlocks, dependent: :destroy

  has_attached_file :evolve_animation,
                    styles: { medium: "300 x 300>",
                              small: "150x150>",
                              thumb: "100 x 100>",
                              tiny: "50 x 50>"}

  validates_attachment_content_type :evolve_animation, :content_type => /\Aimage\/.*\Z/
  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :max_hp, presence: {message: 'Must be entered'}
  validates :element_id, presence: {message: 'Must be entered'}
  validates :job_id, presence: {message: 'Must be entered'}
  validates :dmg_modifier, presence: {message: 'Must be entered'}
  validates :hp_modifier, presence: {message: 'Must be entered'}
  validates :description, presence: {message: 'Must be entered'}
  validates :evolved_from_id, presence: {message: 'Must be entered'}
  validates :summon_cost, presence: {message: 'Must be entered'}

  def self.evolved
    self.joins(:evolved_from)
  end

  def party_member_id(user)
    members.find_by_party_id(user.parties.first.id)
  end

  def ability_equipping_for(current_user)
    ability_equippings.where(user: current_user).first
  end

  def monster_skin_equipping_for(current_user)
    monster_skin_equippings.where(user: current_user).first
  end

  def count_party_members(user_id)
    find_by_user_id(user_id).members.count
  end

  def image(user)
    self.monster_skin_equippings.where(user_id: user).first.monster_skin.avatar.url(:small)
  end

  def evolution_lookup
  end

end
