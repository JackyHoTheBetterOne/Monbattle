class MonsterSkinPurchase < ActiveRecord::Base
  belongs_to :user
  belongs_to :monster_skin

  validates :user_id, presence: {message: 'Must be entered'}
  validates :monster_skin_id, presence: {message: 'Must be entered'},
                              uniqueness: {scope: :user_id}

  def self.on_monster_unlock(params = {})
    @user_id = params[:user_id]
    @mon_skin_id = params[:mon_skin_id]
    if where(user_id: @user_id, monster_skin_id: @mon_skin_id).empty?
      create(user_id: @user_id, monster_skin_id: @mon_skin_id)
    end
  end

end
