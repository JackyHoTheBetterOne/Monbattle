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
    @guild = current_user.summoner.guild

    object = {}
    object[:area_id] = @area.id
    object[:guild_id] = @guild.id
    object[:summoner_id] = current_user.summoner.id

    summoner_score_array = Score.search_summoner_level_score(object)
    guild_score_array = Score.search_guild_level_score(object)

    @summoner_score = ScoreDecorator.new(summoner_score_array[0]) unless summoner_score_array.empty?
    @guild_score = ScoreDecorator.new(guild_score_array[0]) unless guild_score_array.empty?

    render "selection"
  end
end



