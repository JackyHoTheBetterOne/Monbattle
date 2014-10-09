class MonsterSkinEquippingsController < ApplicationController
    # before_action :authenticate_user!
  before_action :find_monster_skin_equipping, only: [:update]
  before_action :find_party
  before_action :find_user
  before_action :find_monster


  def create
    @monster_skin_equipping = MonsterSkinEquipping.new monster_skin_equipping_params
    respond_to do |format|
      if @monster_skin_equipping.save
        format.html { redirect_to @party, notice: "hurrah" }
        format.js { render :action }
      else
        format.html { redirect_to @party, notice: "You fail" }
      end
    end
  end

  def update
    @monster_skin_equipping.update_attributes(monster_skin_equipping_params)
    respond_to do |format|
      if @monster_skin_equipping.save
        format.html { redirect_to @party, notice: "hurrah" }
        format.js { render :action }
      else
        format.html { redirect_to @party, notice: "You fail" }
      end
    end
  end

  private

  def find_party
    @party = Party.find params[:monster_skin_equipping][:party_id]
  end

  def find_user
    @user = User.find params[:monster_skin_equipping][:user_id]
  end

  def find_monster
    @monster = Monster.find params[:monster_skin_equipping][:monster_id]
  end

  def find_monster_skin_equipping
    @monster_skin_equipping = MonsterSkinEquipping.find params[:id]
  end


  def monster_skin_equipping_params
    params.require(:monster_skin_equipping).permit(:user_id, :monster_skin_id, :monster_id)
  end
end
