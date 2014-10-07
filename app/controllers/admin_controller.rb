class AdminController < ApplicationController

  def index
    @party = Party.new
    @parties = Party.all
    if current_user.admin == false
      redirect_to illegal_path
    end
  end
end
