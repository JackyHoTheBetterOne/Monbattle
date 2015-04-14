class GuildsController < ApplicationController
  layout "facebook_landing"

  def gate
  end

  def index
    level = current_user.summoner.level
    @guilds = GuildDecorator.collection(Guild.general_search(params[:guild_search], level))
  end

  def new
    @guild = Guild.new
  end

  def create
    summoner = current_user.summoner

    @guild = Guild.new guild_params
    @guild.leader = summoner
    @guild.members << summoner
    @guild.save
    
    summoner.led_guild = @guild
    summoner.save
    redirect_to guild_path(@guild)
  end

  def show
    @guild = GuildDecorator.new(Guild.friendly.find(params[:id]))
    @summoner = current_user.summoner
    if @guild.notifications.search_summoner_notification_request(@summoner.name).empty?
      @can_join = true
    else
      @can_join = false
    end
  end


# !@summoner.guild &&

  def check_name_uniqueness
    name = params[:guild_name]
    if Guild.check_name_uniqueness(name)
      render text: "Nay"
    else
      render text: "Yay"
    end
  end

  def destroy
    @guild = Guild.friendly.find(params[:id])
    @guild.destroy
    redirect_to gate_guilds_path
  end



  private
  def guild_params
    params.require(:guild).permit(:name, :description, :minimum_level)
  end


end
