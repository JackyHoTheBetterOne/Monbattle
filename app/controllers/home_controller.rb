class HomeController < ApplicationController
  layout "facebook_landing", except: [:index]

  def index
    @base_mons = MonsterUnlock.base_mons(current_user)
    @abilities = Ability.all
    @ability_equippings = AbilityEquipping.all
    @members = current_user.parties.first.members
  end

  def show
  end

  def store
    @abilities = Ability.all.order(:created_at).limit(8)
  end

  def facebook
  end

  def level_select
    render new_battle_path, layout: "facebook_landing"
  end

  def illegal_access
  end

  private

end
