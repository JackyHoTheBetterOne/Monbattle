class BattleLevelsController < ApplicationController
  before_action :find_battle_level, except: [:index, :create]

  def index
    @battle_level = BattleLevel.new
    @battle_levels = policy_scope(BattleLevel.all)
    @region = Region.new
    @region.areas.build
  end

  def create
    @battle_level = BattleLevel.new battle_level_params
    authorize @battle_level
    if @battle_level.save
      redirect_to parties_path, notice: "Battle Level Created"
    else
      render :new
    end
  end

  def destroy
    authorize @battle_level
    if @battle_level.destroy
      redirect_to parties_path, notice: "Battle Level Removed"
    else
      redirect_to parties_path, notice: "Failure"
    end
  end

  def update
    authorize @battle_level
    @battle_level.update_attributes(battle_level_params)
    if @battle_level.save
      redirect_to parties_path, notice: "Success!"
    else
      render :new
    end
  end

private

  def battle_level_params
    params.require(:battle_level).permit(:name, :item_given, :exp_given, :background, :gp_reward, :mp_reward, :vk_reward,
                                         :start_cutscene, :end_cutscene)
  end

  def find_battle_level
    @battle_level = BattleLevel.find params[:id]
  end

end
