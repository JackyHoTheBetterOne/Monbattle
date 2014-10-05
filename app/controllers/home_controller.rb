class HomeController < ApplicationController
  before_action :find_party
  before_action :find_user

  def index
    @base_mons = MonsterUnlock.base_mons(current_user)
    @abilities = Ability.all
  end

  def show
  end

  private

  def find_party
    @party = current_user.parties.first
  end

  def find_user
    @user = current_user
  end

end
