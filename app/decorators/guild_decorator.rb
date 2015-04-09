class GuildDecorator
  attr_reader :guild

  def initialize(guild)
    @guild = guild
  end

  def self.collection(guilds)
    guild_collection = []
    guilds.each do |g|
      guild_collection << self.new(g)
    end
    return guild_collection
  end

  def maximum_member_count
    10
  end

  def current_member_count
    @guild.members.count
  end

  def method_missing(method_name, *args, &block)
    guild.send(method_name, *args, &block)
  end

  def respond_to_missing?(method_name, include_private = false)
    guild.respond_to?(method_name, include_private) || super
  end 

end