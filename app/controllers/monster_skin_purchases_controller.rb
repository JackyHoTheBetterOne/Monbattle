class MonsterSkinPurchasesController < ApplicationController
  # before_action :authenticate_user!
  before_action :find_monster_skin_purchase, only: [:destroy]
  before_action :find_monster_skin, only: [:create]

  def create
    # render text: params.to_s
    @monster_skin_purchase = @monster_skin.monster_skin_purchases.new monster_skin_purchase_params
    if @monster_skin_purchase.save
      redirect_to admin_index_path, notice: "Unlocked!"
    else
      redirect_to admin_index_path, notice: "You fail"
    end
  end

  def destroy
    # render text: params.to_s
    if @monster_skin_purchase.destroy
      redirect_to admin_index_path, notice: "Monster Locked for User!"
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
