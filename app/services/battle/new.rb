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
  attribute :current_region
  attribute :event_toggle
  attribute :is_event
  attribute :messages
  attribute :event_areas

  def call
    @events = Area.where("start_date IS NOT NULL AND is_guild IS FALSE").order(:end_date)
    self.event_areas = []

    @events.each do |e|
      if e.end_date > Time.now 
        self.event_areas << e
      end
    end

    if event_toggle
      self.is_event = true
    else 
      self.is_event = false
    end
    
    self.summoner = user.summoner
    @summoner = summoner
    self.messages = @summoner.general_messages
    @summoner.general_messages = []
    @summoner.save

    self.battle = Battle.new

    self.regions = Region.order(:id).all.unlocked_regions(summoner.completed_regions)

    if Region.find_by_name(session_area_filter)
      self.map_url = Region.find_by_name(session_area_filter).map.url(:cool)
      self.current_region = session_area_filter
    else
      self.map_url = regions.last.map.url(:cool)
      self.current_region = regions.last.name
    end

    if params_area_filter
      self.areas = Area.order(:order).filter(params_area_filter).unlocked_areas(summoner.completed_areas)
    elsif session_area_filter
      self.areas = Area.order(:order).filter(session_area_filter).unlocked_areas(summoner.completed_areas)
    else
      self.areas = Area.order(:order).filter(regions.last.name).unlocked_areas(summoner.completed_areas)
    end

    self.areas = self.areas
    self.areas.reverse!

    if params_level_filter
      self.levels = BattleLevel.order(:order).filter(params_level_filter).unlocked_levels(summoner.beaten_levels)
    else
      self.levels = BattleLevel.order(:order).filter(areas.first.name).unlocked_levels(summoner.beaten_levels)
    end

    self.levels.reverse!

    if user 
      self.monsters = user.parties.first.monster_unlocks
    end
  end
end


