class MonsterUnlocksController < ApplicationController
  # before_action :authenticate_user!
  before_action :find_monster_unlock, only: [:destroy]
  def create
    # render text: params.to_s
    @monster_unlock = MonsterUnlock.new monster_unlock_params
    if @monster_unlock.save
      redirect_to admin_index_path, notice: "Unlocked!"
    else
      redirect_to admin_index_path, notice: "You fail"
    end
  end

  def destroy
    # render text: params.to_s
    @monster_unlock.destroy
    redirect_to admin_index_path, notice: "Monster Locked for User!"
  end

  private

  def monster_unlock_params
    params.require(:monster_unlock).permit(:user_id, :monster_id)
  end

  def find_monster_unlock
    @monster_unlock = MonsterUnlock.find params[:id]
  end
end
