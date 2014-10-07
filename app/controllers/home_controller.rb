class HomeController < ApplicationController
  layout "facebook_landing"

  def index
    @base_mons = MonsterUnlock.base_mons(current_user)
    @abilities = Ability.all
    @ability_equippings = AbilityEquipping.all
    @members = Member.all
  end

  def show
  end

  def facebook
  end

  def level_select
    render new_battle_path, layout: "facebook_landing"
  end

  def illegal_access
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
