class Monster < ActiveRecord::Base

  belongs_to :job
  belongs_to :element
  belongs_to :personality
  belongs_to :rarity

  has_many :evolutions, class_name: "Monster",
                        foreign_key: "evolved_from_id"
  belongs_to :evolved_from, class_name: "Monster"
  
  belongs_to :passive, class_name: "Ability"

  has_many :monster_skin_equippings, dependent: :destroy
  has_many :monster_skin_equipped_skins, through: :monster_skin_equippings, source: :monster_skin
  has_many :monster_skin_equipped_users, through: :monster_skin_equippings, source: :user

  has_many :monster_assignments
  has_many :battle_levels, through: :monster_assignments

  has_many :ability_equippings, through: :monster_unlocks
  has_many :monster_unlocks, dependent: :destroy
  has_many :users, through: :monster_unlocks
  has_many :members, through: :monster_unlocks, dependent: :destroy
  has_many :thoughts, through: :personality

  has_attached_file :evolve_animation,
                    styles: { medium: "300 x 300>",
                              small: "150x150>",
                              thumb: "100 x 100>",
                              tiny: "50 x 50>"}

  validates_attachment_content_type :evolve_animation, :content_type => /\Aimage\/.*\Z/
  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :max_hp, numericality: {greater_than_or_equal_to: 0}
  validates :element_id, presence: {message: 'Must be entered'}
  validates :job_id, presence: {message: 'Must be entered'}
  validates :description, presence: {message: 'Must be entered'}
  validates :evolved_from_id, presence: {message: 'Must be entered'}
  validates :summon_cost, numericality: {greater_than_or_equal_to: 0}
  validates :rarity_id, presence: {message: 'Must be entered'}

  before_save :set_keywords
  before_destroy :check_for_default
  after_update :unlock_for_admins

  scope :search, -> (keyword) {
    if keyword.present?
      where("keywords LIKE ?", "%#{keyword.downcase}%")
    end
  }

  scope :alphabetical, -> {
    order("lower(name)")
  }

  scope :worth, -> (rarity) {
    where(rarity_id: Rarity.worth(rarity))
  }

  scope :can_win, -> (rarity) {
    @rarity_id   = Rarity.worth(rarity)
    where(evolved_from_id: 0, rarity_id: @rarity_id)
  }


  def self.base_mon
    where(evolved_from_id: 0)
  end

  def find_default_skin_id(skin_name)
    MonsterSkin.find_by(name: skin_name).id
  end

  def find_default_abil_id(abil_name)
    Ability.find_by(name: abil_name).id
  end

  def default_skin_img
    MonsterSkin.find(self.default_skin_id).portrait.url(:thumb)
  end

  def default_sock1_name
    Ability.find(self.default_sock1_id).name
  end

  def default_sock2_name
    Ability.find(self.default_sock2_id).name
  end

  def default_sock_name(sock_id)
    Ability.find_name(sock_id).first
  end

  def self.default_monsters
    ["Green Bubbles", "Saphira"]
  end

  def self.find_default_monster_ids
    where(name: default_monsters).pluck(:id)
  end

  def find_user(user_name)
    User.find_by_user_name(user_name)
  end

  def self.mon_abils(monster)
    find_by_id(monster).job.abilities
  end

  def self.find_name(id)
    where(id: id).pluck(:name)
  end


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

  def set_defaults
    self.default_skin_id  = find_default_skin_id("Sack")
    self.default_sock1_id = find_default_abil_id("Slap")
    self.default_sock2_id = find_default_abil_id("Groin Kick")
    if self.rarity.name == "npc"
      self.default_sock3_id = find_default_abil_id("NPC AOE 200 PR Debuff 200-3")
      self.default_sock4_id = find_default_abil_id("NPC AOE 400 PR Debuff 200-3")
    end
  end

  private
  def set_keywords
    level_array = []
    self.battle_levels.each do |b|
      level_array << b.name.downcase
    end
    if self.evolved_from != nil
      self.keywords = [name, description, self.job.name, self.element.name, self.evolved_from.name, self.evolved_from.name]
                        .map(&:downcase).concat([max_hp, summon_cost]).join(" ")
    else
      self.keywords = [name, description, self.job.name, self.element.name]
                        .map(&:downcase).concat([max_hp, summon_cost]).join(" ")
    end
    self.keywords += level_array.join(" ")
  end

  def check_for_default
    if Monster.default_monsters.include? self.name
      false
    end
  end

  def unlock_for_admins
    if self.rarity.try(:name) == "npc"
      @user = find_user("NPC")
    else
      @user = find_user("admin")
    end
    if self.users.where(id: @user).exists?
      MonsterUnlock.find_by(user_id: @user.id, monster_id: self.id).destroy
      MonsterSkinEquipping.find_by(user_id: @user.id, monster_id: self.id).destroy
    end
    MonsterUnlock.create(user_id: @user.id, monster_id: self.id)
    MonsterSkinEquipping.create(user_id: @user.id, monster_id: self.id, monster_skin_id: self.default_skin_id)
  end

end
