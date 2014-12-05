class Fight < ActiveRecord::Base
  belongs_to :party
  belongs_to :battle
  after_create :quest_start

  def quest_start
    @date = Time.now
    @party = self.party
    if Battle.find_matching_date(@date, @party).count == 0
      @party.user.summoner.quest_begin 
      @party.user.summoner.clear_daily_achievement
      @party.user.summoner.clear_daily_battles
    end
  end
end
