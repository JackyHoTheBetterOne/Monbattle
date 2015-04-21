class GbattleController < ApplicationController
  layout "facebook_landing"
  def selection
    @areas = Area.gbattle_areas
  end
end
