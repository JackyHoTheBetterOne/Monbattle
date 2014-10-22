class MonsterUnlocksController < ApplicationController
  before_action :find_monster
  before_action :find_monster_unlock, only: [:destroy]

  def create
    @monster_unlock = @monster.monster_unlocks.new monster_unlock_params
    respond_to do |format|
      if @monster_unlock.save

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

  def monster_unlock_params
    params.require(:monster_unlock).permit(:user_id, :monster_id)
  end

end
