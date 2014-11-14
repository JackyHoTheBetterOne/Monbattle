class Ability < ActiveRecord::Base

  belongs_to :target
  belongs_to :stat_target
  belongs_to :element
  belongs_to :abil_socket
  belongs_to :rarity

  has_many :ability_restrictions, dependent: :destroy
  has_many :jobs, through: :ability_restrictions

  has_many :ability_purchases, dependent: :destroy
  # has_many :ability_purchased_users, through: :ability_purchases, source: :user
  has_many :ability_effects, dependent: :destroy
  has_many :effects, through: :ability_effects

  has_many :monster_unlocks, through: :ability_purchases

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
  validates :ap_cost, presence: {message: 'Must be entered'}, numericality: {greater_than_or_equal_to: 0}
  validates :description, presence: {message: 'Must be entered'}
  validates :target_id, presence: {message: 'Must be entered'}
  validates :stat_target_id, presence: {message: 'Must be entered'}
  validates :element_id, presence: {message: 'Must be entered'}
  validates :stat_change, presence: {message: 'Must be entered'}, numericality: {only_integer: true}
  validates :abil_socket_id, presence: {message: 'Must be entered'}
  validates :rarity_id, presence: {message: 'Must be entered'}
  # validates :mp_cost, numericality: {greater_than_or_equal_to: 0}
  # validates :gp_cost, numericality: {greater_than_or_equal_to: 0}

  # validates :min_level, presence: {message: 'Must be entered'}

  delegate :name, to: :ability_equipping, prefix: true

  default_scope { order('abil_socket_id') }
  before_save :set_keywords
  after_create :unlock_for_admin
  after_create :unlock_for_npc
  # after_create :set_former_name_field
  # after_update :change_default_ability_name_for_monsters

# {"name"=>"slap", "target_id"=>"2", "abil_socket_id"=>"2", "stat_target_id"=>"", "rarity_id"=>"", "order_by"=>"name"}
  scope :filter_it, -> (filter = {}) {
    query = self
    query = query.where("name ILIKE ?", "%#{filter["name"]}%")
    query = query.where(rarity_id: filter["rarity_id"]) if filter["rarity_id"].present?
    query = query.where(target_id: filter["target_id"]) if filter["target_id"].present?
    query = query.where(abil_socket_id: filter["abil_socket_id"]) if filter["abil_socket_id"].present?
    query = query.where(stat_target_id: filter["stat_target_id"]) if filter["stat_target_id"].present?
    query = query.order(filter["order_by"])
    return query
  }

  scope :search_query, -> (search) {
    where("name ILIKE ?", "%#{search}%")
  }

  scope :rarity_filter, -> (rarity) {
    where(rarity_id: rarity)
  }

  scope :direct_dmg, -> { order('stat_change')}

  scope :abilities_by_socket, -> { order('abil_socket_id') }

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
    @abil_ids = find_purchased(user).pluck(:ability_id).uniq
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

  scope :excluding, -> (abil) {
    where('id not in (?)', abil)
  }

  def self.order_options
    {
    "Alphabetic"  => "lower(name)",
    "Damage -"    => "stat_change DESC",
    "Damage +"    => "stat_change",
    "AP Cost"     => "ap_cost",
    "Socket"      => "abil_socket_id",
    "Rarity"      => "rarity_id",
    "Target"      => "target_id",
    "Stat Target" => "stat_target_id",
    }
  end

  def self.find_purchased(user)
    AbilityPurchase.where(user_id: user)
  end

  def self.find_abil_ids_through_ability_restriction(job_id)
    AbilityRestriction.find_abilities_avail_for_job_id(job_id)
  end

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

  def socket
    self.abil_socket.socket_num
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

  def port
    self.portrait.url(:thumb)
  end

  def as_json(options={})
    super(
      :methods => [:targeta, :elementa, :stat, :img, :port],
      )
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
