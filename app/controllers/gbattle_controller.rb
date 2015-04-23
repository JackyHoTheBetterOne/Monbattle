class GbattleController < ApplicationController
  layout "facebook_landing"

  def selection
    @areas = Area.gbattle_areas
    @partial = "guild_listing"
  end

  def guild_leadership_board
    @partial = "guild_leadership"
    render "selection"
  end

  def guild_battle_area_levels
    @partial = "guild_battle_levels"
    @area = Area.find_by_name(params[:area_name])
    @levels = @area.battle_levels

    render "selection"
  end



end
