class User::QuestReward
  include Virtus.model
  attribute :summoner, Summoner

  def call
    @questing_summoner = self.summoner
    array = @questing_summoner.completed_daily_quests.dup
    completion_array = @questing_summoner.just_achieved_quests.dup
    Quest.all.each do |q|
      if q.type == "Daily-Achievement" && (!@questing_summoner.completed_daily_quests.include?q.name) && 
          @questing_summoner.name != "NPC" && q.is_active
        if (@questing_summoner.ending_status[q.stat].to_i - @questing_summoner.starting_status[q.stat].to_i) >= 
            q.stat_requirement
          @questing_summoner[q.reward] += q.reward_amount
          array.push(q.name)
          completion_array.push(q.message)
        end
      elsif q.type == "Daily-Turn-Based-Achievement" && (!@questing_summoner.completed_daily_quests.include?(q.name)) &&
        @questing_summoner.name != "NPC" && q.is_active
        successful_entries = []
        self.summoner.daily_battles.each do |b|
          battle = Battle.find(b)
          successful_entries.push(battle.id) if battle[q.stat].to_i < q.stat_requirement && battle.victor != "NPC"
        end
        if successful_entries.count >= q.requirement.to_i
          @questing_summoner[q.reward] += q.reward_amount
          array.push(q.name)
          completion_array.push(q.message)
        end
      end
    end
    @questing_summoner.completed_daily_quests = array
    @questing_summoner.just_achieved_quests = completion_array
    @questing_summoner.save
  end
  
end