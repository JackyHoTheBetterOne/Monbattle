class Monster < ActiveRecord::Base

  # default_scope{ order('updated_at desc') }

  scope :search, -> (keyword) {
    if keyword.present?
      where("keywords LIKE ?", "%#{keyword.downcase}%")
    end
  }

  belongs_to :job
  belongs_to :element
  belongs_to :personality
  belongs_to :rarity

  has_many :evolutions, class_name: "Monster",
                        foreign_key: "evolved_from_id"
  belongs_to :evolved_from, class_name: "Monster"

  has_many :monster_skin_equippings, dependent: :destroy
  has_many :monster_skin_equipped_skins, through: :monster_skin_equippings, source: :monster_skin
  has_many :monster_skin_equipped_users, through: :monster_skin_equippings, source: :user

  has_many :ability_equippings, through: :monster_unlocks
  has_many :monster_unlocks, dependent: :destroy
  has_many :monster_unlocked_users, through: :monster_unlocks, source: :user
  has_many :members, through: :monster_unlocks, dependent: :destroy
  has_many :thoughts, through: :personality

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
  validates :description, presence: {message: 'Must be entered'}
  validates :evolved_from_id, presence: {message: 'Must be entered'}
  validates :summon_cost, presence: {message: 'Must be entered'}
  validates :rarity_id, presence: {message: 'Must be entered'}
  # validates :dmg_modifier, presence: {message: 'Must be entered'}
  # validates :hp_modifier, presence: {message: 'Must be entered'}

  before_save :set_keywords
  after_create :unlock_for_admins
  after_create :set_defaults

  def find_default_skin_id(skin_name)
    MonsterSkin.find_by(name: skin_name).id
  end

  def find_default_abil_id(abil_name)
    Ability.find_by(name: abil_name).id
  end

  # def self.update_default_abil_name(params = {})
  #   @socket_num  = params[:socket_num]
  #   @former_name = params[:former_name]
  #   @new_name    = params[:new_name]

  #   if @socket_num == 1
  #     @mons_to_update_default_abil = where(default_abil_socket1: @former_name)
  #     @mons_to_update_default_abil.each do |mon|
  #       mon.default_abil_socket1 = @new_name
  #       mon.save
  #     end

  #   elsif @socket_num == 2
  #     @mons_to_update_default_abil = where(default_abil_socket2: @former_name)
  #     @mons_to_update_default_abil.each do |mon|
  #       mon.default_abil_socket2 = @new_name
  #       mon.save
  #     end

  #   end
  # end

  # def self.update_default_skin_name(params = {})
  #   @new_name    = params[:new_name]
  #   @former_name = params[:former_name]

  #   @mons_to_update = where(default_skin: @former_name)
  #   @mons_to_update.each do |mon|
  #     mon.default_skin = @new_name
  #     mon.save
  #   end
  # end

  def default_skin_img
    MonsterSkin.find(self.default_skin_id).portrait.url(:thumb)
  end

  def default_sock1_name
    Ability.find(self.default_sock1_id).name
  end

  def default_sock2_name
    Ability.find(self.default_sock2_id).name
  end

  def self.find_default_monster_ids
    @default_monster_names = ["Red Bubbles", "Green Bubbles", "Yellow Bubbles", "Saphira"]
    where(name: @default_monster_names).pluck(:id)
  end

  def find_user(user_name)
    User.find_by_user_name(user_name)
  end

  def self.mon_abils(monster)
    find_by_id(monster).job.abilities
  end

  def self.worth(rarity)
    where(rarity_id: Rarity.worth(rarity))
  end

  def self.find_name(id)
    where(id: id).pluck(:name)
  end

  def self.base_mon
    where(evolved_from_id: 0)
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

  private
  def set_keywords
    if self.evolved_from != nil
      self.keywords = [name, description, self.job.name, self.element.name, self.evolved_from.name, self.evolved_from.name]
                        .map(&:downcase).concat([max_hp, summon_cost]).join(" ")
    else
      self.keywords = [name, description, self.job.name, self.element.name]
                        .map(&:downcase).concat([max_hp, summon_cost]).join(" ")
    end
  end

  def set_defaults
    self.default_skin_id  = find_default_skin_id("Sack")
    self.default_sock1_id = find_default_abil_id("Slap")
    self.default_sock2_id = find_default_abil_id("Groin Kick")
    self.save
  end

  def unlock_for_admins
    case
      when MonsterSkin.all.empty?
      when Ability.all.empty?
      else
        if rarity == "NPC"
          @user = find_user("NPC")
        else
          @user = find_user("admin")
        end

        MonsterUnlock.create(user_id: @user.id, monster_id: self.id)

    end
  end

end
