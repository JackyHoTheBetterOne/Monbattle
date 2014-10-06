class HomeController < ApplicationController

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
    @base_mons = MonsterUnlock.base_mons(current_user)
    @abilities = Ability.all
    @ability_equippings = AbilityEquipping.all
    @members = Member.all
  end

end
