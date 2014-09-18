class AdminController < ApplicationController

  def index
    @fights = Fight.all
    @stat_target = StatTarget.new
    @stat_targets = StatTarget.all
    @monster_skin_purchase = MonsterSkinPurchase.new
    @monster_skin_purchases = MonsterSkinPurchase.all
    @battle = Battle.new
    @battles = Battle.all
    @battle_level = BattleLevel.new
    @battle_levels = BattleLevel.all
    @monster_skin = MonsterSkin.new
    @monster_skins = MonsterSkin.all
    @party = Party.new
    @parties = Party.all
    @member = Member.new
    @members = Members.all
    @monster_unlock = MonsterUnlock.new
    @monster_unlocks = MonsterUnlock.all
    @users = User.all
    @ability_equipping = AbilityEquipping.new
    @ability_equippings = AbilityEquipping.all
    @evolved_state = EvolvedState.new
    @evolved_states = EvolvedState.all
    @monster = Monster.new
    @monsters = Monster.all
    @target = Target.new
    @targets = Target.all
    @element= Element.new
    @elements = Element.all
    @job = Job.new
    @jobs = Job.all
    @effect = Effect.new
    @effects = Effect.all
    @ability = Ability.new
    @abilities = Ability.all
  end
end
