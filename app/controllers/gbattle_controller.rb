class GbattleController < ApplicationController
  layout "facebook_landing"
  before_action :find_area, except: :selection


  include Checky

  def selection
    @areas = Area.gbattle_areas
    @partial = "guild_listing"
    if current_user.summoner.guild
      render "selection"
    else
      flash[:danger] = "You gotta join a guild or create one before you can access the raid battle!"
      redirect_to guild_gate_path
    end
  end

  def guild_leadership_board
    @scores = ScoreDecorator.collection(Score.guild_scores(params[:area_name]))
    @partial = "guild_leadership"
    render "selection"
  end

  def individual_leadership_board
    p "////////////////////////////////////////////////////////////////////"
    p params["summoner_names"]
    p "////////////////////////////////////////////////////////////////////"
    if params["summoner_names"]
      @scores = ScoreDecorator.collection(Score.friend_scores(params[:summoner_names], @area.id))
    else
      @scores = ScoreDecorator.collection(Score.individual_scores(params[:area_name]))
    end
    @partial = "gbattle_individual_leadership"
    render "selection"
  end

  def guild_battle_area_levels
    @partial = "guild_battle_levels"
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

  private

  def find_area
    @area = Area.find_by_name(params[:area_name])
  end

end



