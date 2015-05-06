class User::NotificationResponse
  include Virtus.model
  attribute :notification, Notification
  attribute :summoner, Summoner
  attribute :guild, Guild
  attribute :decision
  attribute :summoner_array
  attribute :message

  def call
    category = notification.category
    case category
    when "message"
      self.message = "This message has been deleted!"
    when "guild_request"
      @summoner = Summoner.find(notification.information_object["summoner_id"])
      @guild = Guild.find(notification.information_object["guild_id"])
      if @summoner.guild
        return self.message = "Sorry, this summoner has already joined a guild!"
      end
      if decision == "yay"
        @guild.members << @summoner
        @guild.save
        @noti = Notification.create!(title: "You have been accepted into " + @guild.name, 
                  content: "Congratz! Now you can post in the guild's wall and join its battles",
                  sent_by: "Monbattle", category: "message")
        @summoner.notifications << @noti
        @summoner.save
        self.message = "Congratz! You've gained a new member!"
      elsif decision == "nay"
        @noti = Notification.create!(title: "You have been rejected by " + @guild.name, 
                  content: "Don't despair! Go find yourself another guild to join!",
                  sent_by: "Monbattle", category: "message")
        @summoner.notifications << @noti
        @summoner.save
        self.message = "Why? What's wrong with him/her?"
      end
    when "ability_present", "monster_present"
      item = nil
      summoner = Summoner.find(notification.information_object["summoner_id"])
      id = summoner.user.id
      if category == "ability_present"
        item = Ability.find(notification.information_object["present_id"])
        AbilityPurchase.create!(ability_id: item.id, user_id: id)
        self.message = "You have earned a new ability, " + item.name +
                        "! Go to the ability teaching page to teach it!"
      else
        item = Monster.find(notification.information_object["present_id"])
        if MonsterUnlock.where("monster_id = #{item.id} AND user_id = #{id}").empty?
          MonsterUnlock.create!(monster_id: item.id, user_id: id)
          self.message = "You have gained a new monster, " + item.name +
                          "! Go to the team edit page to equip it!"
        else 
          self.message = "Sorry, it seems that you already own this monster!"
        end
      end
    end
    self.notification.destroy
  end
end