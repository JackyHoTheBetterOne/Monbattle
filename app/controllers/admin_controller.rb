class AdminController < ApplicationController

  def index
    @abil_socket = AbilSocket.new
    @abil_sockets = AbilSocket.all
    @stat_target = StatTarget.new
    @stat_targets = StatTarget.all
    @target = Target.new
    @targets = Target.all
    @rarity = Rarity.new
    @rarities = Rarity.all
    @job = Job.new
    @jobs = Job.all
    @element = Element.new
    @elements = Element.all
    @personality = Personality.new
    @personalities = Personality.all

    if current_user
      if current_user.admin == false
        redirect_to illegal_path
      end
    end
  end

end
