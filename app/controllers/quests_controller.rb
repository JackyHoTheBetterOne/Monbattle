class QuestsController < ApplicationController
  before_action :find_quest, only: [:update, :destroy]


  def index
    @quests = policy_scope(Quest.search(params[:keyword]))
    @quest = Quest.new
  end

  def create
    @quest = Quest.new(quest_params)
    authorize @quest
    @quest.save
  end

  def update
    authorize @quest
    @quest.update_attributes(quest_params)
    @quest.save
  end

  def destroy
    authorize @quest
    if @quest.destroy
      respond_to do |format|
        format.js
      end
    end
  end


  private

  def quest_params
    params.require(:quest).permit(:name, :description, :stat, :requirement, :is_active, :bonus, 
                                  :icon, :stat_requirement,:reward_amount, :end_date, 
                                  :refresh_date, :quest_type_id, :reward_category_id)
  end

  def find_quest
    @quest = Quest.find(params[:id])
  end
end
