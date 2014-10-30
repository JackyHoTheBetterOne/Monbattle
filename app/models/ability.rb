class Ability < ActiveRecord::Base

  belongs_to :target
  belongs_to :stat_target
  belongs_to :element
  belongs_to :abil_socket
  belongs_to :rarity

  has_many :ability_restrictions, dependent: :destroy
  has_many :jobs, through: :ability_restrictions

  has_many :ability_purchases, dependent: :destroy
  has_many :ability_purchased_users, through: :ability_purchases, source: :user
  has_many :ability_effects, dependent: :destroy
  has_many :effects, through: :ability_effects

  has_many :ability_equippings, dependent: :destroy
  has_many :monster_unlocks, through: :ability_equippings
  has_many :equipped_monsters, through: :ability_equippings, source: :monster
  has_many :equipped_users, through: :ability_equippings, source: :user

  has_attached_file :image,
                    styles: { large: "300 x 375>",
                              medium: "300 x 300>",
                              small: "150x150>",
                              thumb: "100 x 100>",
                              tiny: "50 x 50>" }
  has_attached_file :portrait,
                    styles: { small: "150x150>",
                              thumb: "100 x 100>" }

  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates_attachment_content_type :portrait, :content_type => /\Aimage\/.*\Z/
  validates :name, presence: {message: 'Must be entered'}, uniqueness: true
  validates :ap_cost, presence: {message: 'Must be entered'}
  validates :description, presence: {message: 'Must be entered'}
  validates :target_id, presence: {message: 'Must be entered'}
  validates :stat_target_id, presence: {message: 'Must be entered'}
  validates :element_id, presence: {message: 'Must be entered'}
  validates :stat_change, presence: {message: 'Must be entered'}
  validates :abil_socket_id, presence: {message: 'Must be entered'}
  validates :rarity_id, presence: {message: 'Must be entered'}
  # validates :min_level, presence: {message: 'Must be entered'}

  delegate :name, to: :ability_equipping, prefix: true

  default_scope { order('abil_socket_id') }
  before_save :set_keywords
  after_create :unlock_for_admin
  after_create :unlock_for_npc
  # after_create :set_former_name_field
  # after_update :change_default_ability_name_for_monsters

  scope :name_alphabetical, -> { order('name') }

  scope :search, -> (keyword) {
    if keyword.present?
      where("abilities.keywords LIKE ?", "%#{keyword.downcase}%")
    end
  }

  scope :ap_cost_search, -> (cost) {
    if cost.present?
      where("ap_cost = ?", "#{cost}")
    end
  }

  scope :effect_search, -> (effect) {
    if effect.present?
      joins(:effects).where("effects.keywords LIKE ?", "%#{effect.downcase}%")
    end
  }

  scope :find_abilities_for_socket, -> (socket_num) {
    @socket_id = find_socket_id(socket_num)
    where(abil_socket_id: @socket_id)
  }

  scope :find_default_abilities_available, -> (socket_num, job_id) {
    @socket_id                = find_socket_id(socket_num)
    @job_restricted_abil_ids  = find_abil_ids_through_ability_restriction(job_id)
    where(abil_socket_id: @socket_id, id: @job_restricted_abil_ids)
  }

  scope :abilities_purchased, -> (user) {
    @abil_ids = find_abils_through_ability_purchase(user).pluck(:ability_id)
    where(id: @abil_ids)
  }

  scope :can_win, -> (rarity) {
    @socket_ids = find_socket([1,2]).pluck(:id)
    @rarity_id   = Rarity.worth(rarity)
    where(abil_socket_id: @socket_ids, rarity_id: @rarity_id)
  }

  scope :worth, -> (rarity) {
    where(rarity_id: Rarity.worth(rarity))
  }

  ####################

  def number_of_self_owned(user)
    ability_purchase_records_of_self(user).count
  end

  def number_of_self_equipped(user)
    @abil_purchase_ids = ability_purchase_records_of_self(user).pluck(:id)
    ability_equipping_records_of_self(@abil_purchase_ids).count
  end

  def ability_purchase_records_of_self(user)
    AbilityPurchase.number_of_ability_owned(user, self.id)
  end

  def ability_equipping_records_of_self(abil_purchase_ids)
    AbilityEquipping.find_times_abil_is_equipped(abil_purchase_ids)
  end

  def find_first_abil_purchase_id_not_in_use(user)
    @abil_purchase_ids           = ability_purchase_records_of_self(user).pluck(:id)
    @abil_purchase_ids_in_use    = ability_equipping_records_of_self(@abil_purchase_ids).pluck(:ability_purchase_id)
    @abil_purchase_ids_available = @abil_purchase_ids - @abil_purchase_ids_in_use
    @abil_purchase_ids_available.first
  end

  def number_of_self_available(user)
    number_of_self_owned(user) - number_of_self_equipped(user)
  end

  def self.find_abils_through_ability_purchase(user)
    AbilityPurchase.where(user_id: user)
  end

  def self.find_abil_ids_through_ability_restriction(job_id)
    AbilityRestriction.find_abilities_avail_for_job_id(job_id)
  end

  ###################

  def self.abil_portrait(sock_num)
    find_abilities_for_socket(sock_num).first.portrait.url(:small)
  end

  def self.find_socket(socket_num)
    AbilSocket.where(socket_num: socket_num)
  end

  def self.find_socket_id(sock_num)
    AbilSocket.socket_id(sock_num)
  end

  def find_socket_num(socket_id)
    AbilSocket.find(socket_id).socket_num
  end


  def self.find_name(id)
    where(id: id).pluck(:name)
  end

  def self.abils_for_mon(monster)
    where(id: Monster.mon_abils(monster))
  end

  def slot
    self.abil_socket.socket_num
  end

  def stat
    self.stat_target.name.downcase
  end

  def targeta
    self.target.name.downcase
  end

  def elementa
    self.element.name.downcase
  end

  def modifier
    self.stat_change[0,1]
  end

  def change
    self.stat_change.split("").drop(1).join("")
  end

  def img
    self.image.url(:medium)
  end

  private

  def capitalize_name
    self.name.capitalize!
  end

  protected

  def add_slot
    self.slot = self.abil_socket.socket_num
  end

  private

  def set_keywords
    self.keywords = [name, description, self.targeta, self.stat_target.name, self.element.name].map(&:downcase).
                      concat([ap_cost, stat_change]).join(" ")
  end

  def unlock_for_admin
    if AbilityPurchase.where(user_id: 1, ability_id: self.id).count == 0
      unlock = AbilityPurchase.new
      unlock.user_id = 1
      unlock.ability_id = self.id
      unlock.save
    end
  end

  def unlock_for_npc
    if AbilityPurchase.where(user_id: 1, ability_id: self.id).count == 0
      unlock = AbilityPurchase.new
      unlock.user_id = 2
      unlock.ability_id = self.id
      unlock.save
    end
  end

end
