class GuildsController < ApplicationController
  layout "facebook_landing"
  before_action :find_guild, only: [:show]
  before_action :find_guild_and_notify_members, only: [:destroy]
  before_action :leave_message, only: [:guild_leave]

  def gate
    if current_user.summoner.guild
      redirect_to guild_path(current_user.summoner.guild)
    else
      render "gate"
    end
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
    @summoner = current_user.summoner
    # !@summoner.guild &&
    if @guild.notifications.search_summoner_notification_request(@summoner.name).empty?
      @can_join = true
    else
      @can_join = false
    end
  end


  def check_name_uniqueness
    name = params[:guild_name]
    if Guild.check_name_uniqueness(name)
      render text: "Nay"
    else
      render text: "Yay"
    end
  end

  def destroy
    @guild.destroy
    render "gate"
  end


  def kick_member
    @guild = current_user.summoner.guild
    @summoner = Summoner.find_by_name(params[:summoner_name])

    notification = User::NotificationSending.new(type: "guild_kick_message", 
                                                  guildy: @guild,
                                                  summoner: @summoner)
    notification.call

    @summoner.led_guild = nil
    @summoner.sub_led_guild = nil
    @summoner.guild = nil
    @summoner.save

    render nothing: true
  end


  def guild_leave
    @summoner.led_guild = nil
    @summoner.sub_led_guild = nil
    @summoner.guild = nil
    @summoner.save
    flash.now["success"] = "You are now a guild-free oracle! Go wild!"
    render "gate"
  end




  private
  def find_guild
    @guild = GuildDecorator.new(Guild.friendly.find(params[:id]))
  end

  def leave_message
    @summoner = current_user.summoner
    @guild = @summoner.guild
    notification = User::NotificationSending.new(summoner: @summoner,
                                                 guildy: @guild,
                                                 type: "guild_leave_message")
    notification.call
  end


  def guild_params
    params.require(:guild).permit(:name, :description, :minimum_level)
  end

  def find_guild_and_notify_members
    @guild = Guild.friendly.find(params[:id])
    notification = User::NotificationSending.new(type: "guild_disband_message", 
                                                 summoner_array: @guild.members)
    notification.call
  end
end
