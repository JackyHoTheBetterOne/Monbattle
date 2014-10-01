class BattleLevelsController < ApplicationController
  # before_action :authenticate_user!
  before_action :find_battle_level, except: [:create]

  def create
    @battle_level = BattleLevel.new battle_level_params
    if @battle_level.save
      redirect_to admin_index_path, notice: "Battle Level Created"
    else
      redirect_to admin_index_path, notice: "Failure"
    end
  end

  def destroy
    if @battle_level.destroy
      redirect_to admin_index_path, notice: "Battle Level Removed"
    else
      redirect_to admin_index_path, notice: "Failure"
    end
  end

  def edit
  end

  def update
    @battle_level.update_attributes(battle_level_params)
    if @battle_level.save
      redirect_to admin_index_path, notice: "Success!"
    end
  end

private

  def battle_level_params
    params.require(:battle_level).permit(:name, :item_given, :exp_given)
  end

  def find_battle_level
    @battle_level = BattleLevel.find params[:id]
  end

end