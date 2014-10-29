class AbilityPurchase < ActiveRecord::Base
  belongs_to :ability
  belongs_to :user

  validates :ability_id, presence: {message: 'Must be entered'},
                         uniqueness: {scope: :user_id}
  validates :user_id, presence: {message: 'Must be entered'}

  def self.on_monster_unlock(params = {})
    @user_id = params[:user_id]
    @abil_id = params[:abil_id]
    @ability_purchase_check = where(user_id: @user_id, ability_id: @abil_id)
    if @ability_purchase_check.empty?
      create(user_id: @user_id, ability_id: @abil_id)
    else
      @ability_purchase = @ability_purchase_check.first
      @ability_purchase.amount_owned += 1
      @ability_purchase.save
    end
  end

  def self.create_default_abil_purchase(user_id, abil_id)
  end

  def self.abils_purchased(user)
    self.where(user_id: user)
  end

  def self.unlock_check(user, ability_id)
    where(user_id: user, ability_id: ability_id)
  end

end
