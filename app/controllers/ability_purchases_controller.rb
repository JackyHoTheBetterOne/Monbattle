class AbilityPurchasesController < ApplicationController
  before_action :find_ability

  def create
    # render text: params.to_s
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

  def find_ability
    @ability = Ability.find params[:ability_purchase][:ability_id]
  end

  def ability_purchase_params
    params.require(:ability_purchase).permit(:user_id, :ability_id)
  end

end
