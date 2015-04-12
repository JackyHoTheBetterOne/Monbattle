class User::CodyUnlocky
  include Virtus.model
  attribute :user, User 
  attribute :code, UnlockCode
  attribute :result, Hash

  def call
    case self.code.category
      when "monster"
        monster_id = code.item_id
        @monster = Monster.find(code.item_id)
        user_id = user.id
        MonsterUnlock.create!(monster_id: monster_id, user_id: user_id)
        code.destroy

        result[:type] = "monster"
        result[:item_name] = @monster.name
        result[:image] = @monster.default_skin_img
        result[:namey] = user.namey
        return result
      when "ability"
        ability_id = code.item_id
        @ability = Ability.find(code.item_id)
        user_id = user.id
        AbilityPurchase.create!(ability_id: ability_id, user_id: user_id)
        code.destroy

        result[:type] = "ability"
        result[:item_name] = @ability.name
        result[:image] = @ability.portrait.url(:small)
        result[:namey] = user.namey
        return result
      when "unlock_game"
        @user = user
        @user.game_unlock = code.code
        @user.save
        code.destroy

        result[:type] = "game_unlock"
        result[:item] = "game_unlock"
        result[:image] = "https://s3-us-west-2.amazonaws.com/monbattle/images/frank.jpg"
        result[:namey] = user.namey
        result[:item_name] = "Game Access"
        return result
    end
  end
end