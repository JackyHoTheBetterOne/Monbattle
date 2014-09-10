class MonsterUnlocksController < ApplicationController
  # before_action :authenticate_user!
  
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
  end

  private

  def monster_unlock_params
    params.require(:monster_unlock).permit(:user_id, :monster_id)
  end

end
