class MonsterSkinPurchasesController < ApplicationController
  before_action :find_monster_skin_purchase, only: [:destroy]
  before_action :find_monster_skin

  def create
    @monster_skin_purchase = @monster_skin.monster_skin_purchases.new monster_skin_purchase_params
    respond_to do |format|
      if @monster_skin_purchase.save
        format.html { redirect_to monster_skins_path, notice: "Unlocked!" }
        format.js { render :action }
      else
        redirect_to monster_skins_path, notice: "You fail"
      end
    end
  end

  def destroy
    respond_to do |format|
      if @monster_skin_purchase.destroy
        format.html { redirect_to monster_skins_path, notice: "Monster Locked for User!" }
        format.js { render :action }
      else
        redirect_to monster_skins_path, notice: "You Fail"
      end
    end
  end

  private

  def monster_skin_purchase_params
    params.require(:monster_skin_purchase).permit(:user_id, :monster_skin_id)
  end

  def find_monster_skin_purchase
    @monster_skin_purchase = MonsterSkinPurchase.find params[:id]
  end

  def find_monster_skin
    @monster_skin = MonsterSkin.find params[:monster_skin_id]
  end

end
