class HomeController < ApplicationController

  def index
    @base_mons = MonsterUnlock.base_mons(current_user)
    @abilities = Ability.all
    @ability_equippings = AbilityEquipping.all
    @members = Member.all
  end

end
