class User::NotificationSending
  include Virtus.model
  attribute :type
  attribute :summoner, Summoner
  attribute :information_object, Hash
  attribute :message
  attribute :present


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
    end
  end



end