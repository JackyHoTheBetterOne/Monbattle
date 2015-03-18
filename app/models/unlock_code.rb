class UnlockCode < ActiveRecord::Base
  validates :code, presence: true, uniqueness: true
  validates :category, presence: true

# SecureRandom.urlsafe_base64(n)[0..n-1]

  def unlock(user)
    case self.category
    when "monster"
      monster_id = self.item_id
      @monster = Monster.find(self.item_id)
      user_id = user.id
      MonsterUnlock.create!(monster_id: monster_id, user_id: user_id)
      self.destroy

      object = Hash.new
      object["type"] = "monster"
      object["item"] = @monster
      return object
    when "ability"
      ability_id = self.item_id
      @ability = Ability.find(self.item_id)
      user_id = user.id
      AbilityPurchase.create!(ability_id: ability_id, user_id: user_id)
      self.destroy

      object = Hash.new
      object["type"] = "ability"
      object["item"] = @ability
      return object
    when "unlock_game"
      @user = user
      @user.game_unlock = self.code
      @user.save
      self.destroy

      object = Hash.new
      object["type"] = "game_unlock"
      object["item"] = "game_unlock"
      return object
    end
  end
end
