class AbilityPurchasesController < ApplicationController
  before_action :find_ability, except: [:update]

  def create
    @ability_purchase = @ability.ability_purchases.new ability_purchase_params
    respond_to do |format|
      if @ability_purchase.save
        format.js { render :action}
        format.html { redirect_to abilities_path, notice: "Unlocked!" }
      else
        redirect_to abilities_path, notice: "You fail"
      end
    end
  end

  def update
    user_id = current_user.id

    count = AbilityPurchase.where(user_id: user_id).where("learner_id IS NOT NULL").count

    @ability_purchase = AbilityPurchase.friendly.find(params[:id])
    @monster_unlock = MonsterUnlock.find_by_id_code(update_params[:learner_id])
    @ability_purchase.learner_id = @monster_unlock.id
    @ability_purchase.save

    if count == 4
      render text:"successfirst"
    else
      render text: "success"
    end
  end


  # def destroy
  #   respond_to do |format|
  #     if @ability_purchase.destroy
  #       AbilityEquipping.where(ability_id: params[:ability_id]).destroy_all
  #       format.html { redirect_to abilities_path, notice: "Locked for User!" }
  #       format.js { render :action}
  #     else
  #       redirect_to abilities_path, notice: "You fail"
  #     end
  #   end
  # end

  private

  def update_params
    params.permit(:learner_id)
  end

  def find_ability
    @ability = Ability.find params[:ability_purchase][:ability_id]
  end

  def ability_purchase_params
    params.require(:ability_purchase).permit(:user_id, :ability_id)
  end

end
