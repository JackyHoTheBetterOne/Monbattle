class Battle::New
  include Virtus.model
  attribute :params_area_filter
  attribute :params_level_filter
  attribute :session_area_filter
  attribute :user, User 

  attribute :summoner, Summoner
  attribute :regions, Region
  attribute :areas, Area
  attribute :battle, Battle 
  attribute :levels, BattleLevel
  attribute :monsters, Monster
  attribute :map_url

  def call
    self.battle = Battle.new
    self.summoner = user.summoner
    self.regions = Region.all.unlocked_regions(summoner.completed_regions)

    Party.generate(user)

    if Region.find_by_name(session_area_filter)
      self.map_url = Region.find_by_name(session_area_filter).map.url(:cool)
    else
      self.map_url = regions.last.map.url(:cool)
    end

    if params_area_filter
      self.areas = Area.filter(params_area_filter).unlocked_areas(summoner.completed_areas)
    elsif session_area_filter
      self.areas = Area.filter(session_area_filter).unlocked_areas(summoner.completed_areas)
    else
      self.areas = []
    end

    if params_level_filter
      self.levels = BattleLevel.order(:id).filter(params_level_filter).unlocked_levels(summoner.beaten_levels)
    else
      self.levels = []
    end

    if user 
      self.monsters = user.parties.first.monster_unlocks
    end
  end
end

