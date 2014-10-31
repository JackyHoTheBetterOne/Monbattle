class AbilityEquipping < ActiveRecord::Base
  # belongs_to :ability
  belongs_to :monster_unlock
  belongs_to :ability_purchase
  has_one :ability, through: :ability_purchase

  validates :ability_purchase_id, presence: {message: 'Must be entered'},
                         uniqueness: true

  validates :monster_unlock, presence: {message: 'Must be entered'}

  scope :find_times_abil_is_equipped, -> (abil_purchase_ids) {
    where(ability_purchase_id: abil_purchase_ids)
  }

  scope :monster_unlocks, -> (monster_unlocks) {
    where(monster_unlock_id: monster_unlocks)
  }

  scope :monsters_owned, -> (user) {
    where(monster_unlock_id: user.monster_unlocks.pluck(:id))
  }

  # after_create
  # after_update

  def self.find_ability_equipping_for_socket(monster_unlock, socket_num)
    @purchase_id_used_by_self = monster_unlock.find_abil_purchases_in_socket(socket_num).first
    self.find_by_ability_purchase_id(@purchase_id_used_by_self)
  end

  def find_user_id(monster_unlock)
    User.find(monster_unlock.user_id).id
  end

  private

  def self.record_find(monster_unlock, ability)
    find_by(monster_unlock_id: monster_unlock, ability_id: ability)
  end

end
