class AbilityPurchase < ActiveRecord::Base
  belongs_to :ability
  belongs_to :user
  has_one :ability_equipping

  validates :ability_id, presence: {message: 'Must be entered'}
  validates :user_id, presence: {message: 'Must be entered'}

  def self.on_monster_unlock(params = {})
    @user_id           = params[:user_id]
    @abil_id           = params[:abil_id]
    @monster_unlock_id = params[:monster_unlock_id]
    @ability_purchase  = self.new(user_id: @user_id, ability_id: @abil_id)
    @ability_purchase.save
    AbilityEquipping.create(ability_purchase_id: @ability_purchase.id,
                            monster_unlock_id: @monster_unlock_id
                            )
  end

  scope :number_of_ability_owned, -> (user, ability) {
    where(ability_id: ability, user_id: user)
  }

  scope :find_ability_purchases_for_socket, -> (socket_num) {
    @ability_ids = Ability.find_abilities_for_socket(socket_num)
    where(ability_id: @ability_ids)
  }

  # def self.check_for_equipped_ability

  # end

  # def self.create_default_abil_purchase(user_id, abil_id)
  # end

  def self.abils_purchased(user)
    self.where(user_id: user)
  end

  def self.unlock_check(user, ability_id)
    where(user_id: user, ability_id: ability_id)
  end

end
