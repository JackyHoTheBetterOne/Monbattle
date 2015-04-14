class User::NotificationSending
  include Virtus.model
  attribute :type
  attribute :summoner, Summoner
  attribute :guildy, Guild
  attribute :information_object, Hash
  attribute :present
  attribute :summoner_array
  attribute :message


  def call
    case type
    when "guild_join_request"
      guild = Guild.find_by_name(information_object["guild_name"])
      notification = Notification.create!(title: "Guild Request",
                                          content: "Oracle " + summoner.name + " has requested to join your guild!",
                                          category: 'guild_request',
                                          sent_by: summoner.name,
                                          information_object: {guild_id: guild.id, summoner_id: summoner.id})
      guild.notifications << notification
      guild.save
    when "guild_disband_message"
      summoner_array.each do |m|
        notification = Notification.create!(title: "Your guild has been disbanded", 
                                           content: "Everything is ok though. Go find yourself another guild!",
                                           sent_by: "Monbattle", category: "message")
        m.notifications << notification
        m.save
      end
    when "guild_kick_message"
      notification = Notification.create!(title: "You have been kicked from " + guildy.name,
                      content: "It's not you. It's them. Go join a guild that really gets you!",
                      category: "message", sent_by: "Monbattle")
      summoner.notifications << notification
      summoner.save
    end
  end
end