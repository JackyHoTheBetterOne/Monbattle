class BattleLevelsController < ApplicationController
  before_action :find_battle_level, except: [:index, :create]
  before_action :set_event_status, only: [:create, :update]

  def index
    @battle_levels = policy_scope(BattleLevel.order("name ASC").search(params[:keyword]))
  end

  def create
    @battle_level = BattleLevel.new(battle_level_params)
    authorize @battle_level
    @battle_level.save
  end

  def destroy
    authorize @battle_level
    @battle_level.destroy
    respond_to do |format|
      format.js
    end
  end

  def update
    authorize @battle_level
    @battle_level.update_attributes(battle_level_params)
    @battle_level.save
  end

private

  def battle_level_params
    params.require(:battle_level).permit(:id, :name, :background, :exp_given, :gp_reward, :mp_reward, 
                                          :stamina_cost, :music,  :unlocked_by_id, :area_id, 
                                          :description, :victory_message, :ability_reward, :time_requirement,
                                          :enh_reward, :asp_reward, :order)
  end

  def find_battle_level
    @battle_level = BattleLevel.find params[:id]
  end

  def set_event_status
    if @battle_level.area.start_date != nil && @battle_level.event == false
      @battle_level.event = true
      @battle_level.save
    end
  end
end






