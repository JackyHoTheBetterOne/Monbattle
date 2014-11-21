class Fight < ActiveRecord::Base
  belongs_to :party
  belongs_to :battle
  after_create :quest_start

  def quest_start
    @date = Time.now.utc.to_date
    @party = self.party
    if Battle.find_matching_date(@date, @party).count == 1 
      @party.user.summoner.quest_begin 
      @party.user.summoner.clear_daily_achievement
    end
  end
end
