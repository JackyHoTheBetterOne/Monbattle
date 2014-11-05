class AbilityEquippingForUsersController < ApplicationController
  before_action :find_user
  before_action :find_ability_purchases
  before_action :find_ability_purchase
  before_action :find_ability
  before_action :find_old_ability_purchase
  before_action :find_old_ability
  before_action :find_monster_unlock
  before_action :find_socket_num
  # after_action :ability_owned_count
  # after_action :find_ability_available
  # after_action :ability_available_count
  # after_action :old_ability_owned_count
  # after_action :find_old_ability_available
  # after_action :old_ability_available_count

  def update
    @old_ability_purchase.update(monster_unlock_id: 0)
    @ability_purchase.update_attributes(ability_purchase_params)
    respond_to do |format|
      if @ability_purchase.save
         format.js { render :action }
         format.html { render :new }
      else
        @old_ability_purchase.update(monster_unlock_id: @monster_unlock.id)
        format.js { render :new }
      end
    end
  end

  private

  def find_user
    @user = current_user
  end

  def find_ability_purchases
    @ability_purchases = @user.ability_purchases
  end

  def find_ability_purchase
    @ability_purchase = AbilityPurchase.find params[:id]
  end

  def find_ability
    @ability = @ability_purchase.ability
  end

  def find_old_ability_purchase
    @old_ability_purchase = AbilityPurchase.find params[:ability_equipping][:old_abil_purch_id]
  end

  def find_old_ability
    @old_ability = @old_ability_purchase.ability
  end

  def find_monster_unlock
    @monster_unlock = MonsterUnlock.find params[:ability_equipping][:monster_unlock_id]
  end

  def find_socket_num
    @socket_num = (params[:ability_equipping][:socket_num]).to_i
  end

  def ability_purchase_params
    params.require(:ability_equipping).permit(:monster_unlock_id)
  end

  # def ability_owned_count
  #   @abil_own = @ability_purchases.owned(@ability).count
  # end
  # def find_ability_available
  #   @abil_available = @ability_purchases.not_equipped(@ability)
  # end
  # def ability_available_count
  #   @abil_available_count = @abil_available.count
  # end
  # def old_ability_owned_count
  #   @old_abil_own = @ability_purchases.owned(@old_ability).count
  # end
  # def find_old_ability_available
  #   @old_abil_avail = @ability_purchases.not_equipped(@old_ability)
  # end
  # def old_ability_available_count
  #   @old_abil_avail_count = @old_abil_avail.count
  # end

end
