class GbattleController < ApplicationController
  layout "facebook_landing"
  include Checky

  def selection
    @areas = Area.gbattle_areas
    @partial = "guild_listing"
  end

  def guild_leadership_board
    @area = Area.find_by_name(params[:area_name])
    @scores = ScoreDecorator.collection(Score.guild_scores(params[:area_name]))
    @partial = "guild_leadership"
    render "selection"
  end

  def individual_leadership_board
    @area = Area.find_by_name(params[:area_name])
    @scores = ScoreDecorator.collection(Score.individual_scores(params[:area_name]))
    @partial = "gbattle_individual_leadership"
    render "selection"

  end

  def guild_battle_area_levels
    @partial = "guild_battle_levels"
    @area = Area.find_by_name(params[:area_name])
    @levels = @area.battle_levels.order(:order)
    render "selection"
  end
end
