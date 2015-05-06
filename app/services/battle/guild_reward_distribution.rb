class Battle::GuildRewardDistribution
  include Virtus.model
  attribute :area, Area

  def call
    guild_scores = Score.guild_scores(area.name)
    individual_scores = Score.individual_scores(area.name)

    area.reward_object.tiers.each do |t|
      (t.starting..t.ending).each do |n|
        break if individual_scores[n] == nil
        summoner = individual_scores[n].scorapable
        t.rewards.each do |r|
          category = r.type == "Ability" ? "ability_present" : "monster_present"
          Notification.create!(title: "Raid Reward",
                               content: "#{area.name} is over! Here is your reward!",
                               sent_by: "Monbattle",
                               category: category,
                               notificapable_type: "Summoner",
                               notificapable_id: summoner.id,
                               information_object: {
                                summoner_id: summoner.id,
                                present_id: r.id
                                })

        end
      end
    end
  end



end