class HomeController < ApplicationController
  before_action :find_party
  before_action :find_user

  def index
  end

  def show
  end

  def facebook
    render text: "abc"
  end

  private

  def find_party
    @party = current_user.parties.first
  end

  def find_user
    @user = current_user
  end

end
