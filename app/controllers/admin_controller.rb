class AdminController < ApplicationController

  def index
    @party = Party.new
    @parties = Party.all
  end
end
