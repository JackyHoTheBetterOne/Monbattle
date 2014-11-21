class QuestsController < ApplicationController
  def index
    @quests = Quest.all
    @quest = Quest.new
  end

  def create
    @quest = Quest.new(quest_params)
    @quest.save
    render nothing: true
  end

  private

  def quest_params
    params.require(:quest).permit(:name, :description, :stat, :requirement, :is_active, :bonus,
                                  :reward_amount, :end_date, :refresh_date, :quest_type_id, :reward_category_id)
  end
end
