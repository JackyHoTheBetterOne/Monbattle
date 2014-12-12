class AbilityEquippingForUsersController < ApplicationController
  before_action :find_user, :find_ability_purchases, :find_ability_purchase, :find_ability, :find_old_ability_purchase,
                :find_old_ability, :find_mon, :find_socket, :find_abilities

  def update
    @old_ability_purchase.update(monster_unlock_id: 0)
    @ability_purchase.update_attributes(ability_purchase_params)
    respond_to do |format|
      if @ability_purchase.save
        @current_abil_purchase = @mon.abil_purch_in_sock(@socket)
        @abil_avail = @ability_purchases.not_equipped(@ability)
        @abil_avail_count = @abil_avail.count
        @old_abil_avail = @ability_purchases.not_equipped(@old_ability)
        @old_abil_avail_count = @old_abil_avail.count
         format.js { render :action }
         format.html { render :new }
      else
        @old_ability_purchase.update(monster_unlock_id: @mon.id)
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

  def find_mon
    @mon = MonsterUnlock.find params[:ability_equipping][:monster_unlock_id]
  end

  def find_socket
    @socket = (params[:ability_equipping][:socket_num]).to_i
  end

  def find_abilities
    @abilities = Ability.find_default_abilities_available(@socket, @mon.job).
    abilities_purchased(@user).not_including(@ability)
  end

  def ability_purchase_params
    params.require(:ability_equipping).permit(:monster_unlock_id)
  end

end
