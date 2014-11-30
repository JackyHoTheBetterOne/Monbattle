class BattleLevelsController < ApplicationController
  before_action :find_battle_level, except: [:index, :create]

  def index
    @battle_levels = policy_scope(BattleLevel.search(params[:keyword]))
    @battle_level = BattleLevel.new
  end

  def create
    @battle_level = BattleLevel.new(battle_level_params)
    authorize @battle_level
    @battle_level.save
  end

  def destroy
    authorize @battle_level
    @battle_level.destroy
  end

  def update
    authorize @battle_level
    @battle_level.update_attributes(battle_level_params)
    @battle_level.save
  end

private

  def battle_level_params
    params.require(:battle_level).permit(:id, :name, :background, :exp_given, :gp_reward, :mp_reward,
                                          :unlock_id, :area_id)
  end

  def find_battle_level
    @battle_level = BattleLevel.find params[:id]
  end

end
