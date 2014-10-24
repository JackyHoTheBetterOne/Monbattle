class MonsterUnlocksController < ApplicationController
  before_action :find_monster
  before_action :find_user, only: [:create]
  before_action :find_monster_unlock, only: [:destroy]

  def create
    @monster_unlock = @monster.monster_unlocks.new monster_unlock_params
    respond_to do |format|
      if @monster_unlock.save
        AbilityEquipping.default_equip(socket_nums: [1, 2], monster_unlock_id: @monster_unlock.id)
        MonsterSkinEquipping.default_equip(monster_id: @monster.id, user_id: @user_id)
        format.js { render :action }
        format.html { redirect_to monsters_path, notice: "Unlocked!" }
      else
        redirect_to monsters_path, notice: "You fail"
      end
    end
  end

  def destroy
    respond_to do |format|
      if @monster_unlock.destroy
        format.html { redirect_to monsters_path, notice: "Monster Locked for User!" }
        format.js { render :action }
      else
        redirect_to monsters_path, notice: "You fail"
      end
    end
  end

  private

  def find_monster
    @monster = Monster.find(params[:monster_id])
  end

  def find_monster_unlock
    @monster_unlock = MonsterUnlock.find params[:id]
  end

  def find_user
    @user_id = params[:monster_unlock][:user_id]
  end

  def monster_unlock_params
    params.require(:monster_unlock).permit(:user_id, :monster_id)
  end

end
