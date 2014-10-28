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

  # delegate :name, :ap_cost, :description, :min_level, :target_id, :stat_target_id, :element_id,
  #          :stat_change, :abil_socket_id, :image,
  #          to: :monster, prefix: true

  delegate :name, to: :ability_equipping, prefix: true

  default_scope { order('abil_socket_id') }
  before_save :set_keywords
  after_create :unlock_for_admin
  after_create :unlock_for_npc
  after_create :set_former_name_field
  after_update :change_default_ability_name_for_monsters

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

  scope :find_default_abilities_available, -> (socket_num, job_id) {
    @socket_id                = find_socket_id(socket_num)
    @job_restricted_abil_ids  = find_abil_ids_through_ability_restriction(job_id)
    where(abil_socket_id: @socket_id, id: @job_restricted_abil_ids)
  }

  def self.find_abil_ids_through_ability_restriction(job_id)
    AbilityRestriction.find_abilities_avail_for_job_id(job_id)
  end

#####################################################

  def self.find_socket_id(sock_num)
    AbilSocket.socket_id(sock_num)
  end


  def self.default_abil_id(params = {})
    @sock_num = params[:sock_num]
    @abil_name = params[:abil_name]
    @socket_id = find_socket_id(@sock_num)
    where(name: @abil_name, abil_socket_id: @socket_id).first.id
  end

  #################################################################

  def find_socket_num(socket_id)
    AbilSocket.find(socket_id).socket_num
  end

  def self.worth(rarity)
    where(rarity_id: Rarity.worth(rarity))
  end

  def self.find_name(id)
    where(id: id).pluck(:name)
  end

  def self.abil_avail_for_sock(user, socket_num)
    where(id: AbilityPurchase.abils_purchased(user).pluck(:ability_id),
               abil_socket_id: AbilSocket.socket(socket_num))
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

  def change_default_ability_name_for_monsters
    if self.former_name == self.name
    else
      @socket_id = self.abil_socket_id
      @socket_num = find_socket_num(@socket_id)
      Monster.update_default_abil_name(socket_num: @socket_num, former_name: self.former_name, new_name: self.name)
    end
  end

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

  def set_former_name_field
    self.former_name = self.name
    self.save
  end

end
