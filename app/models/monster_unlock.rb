class MonsterUnlock < ActiveRecord::Base
  belongs_to :user
  belongs_to :monster
  has_one    :job, through: :monster
  has_many :ability_purchases

  # has_many :ability_purchases, through: :ability_equippings
  has_many :abilities, through: :ability_purchases
  has_many :members, dependent: :destroy
  has_many :parties, through: :members

  validates :monster_id, presence: {message: 'Must be entered'},
                                    uniqueness: {scope: :user_id}
  validates :user_id, presence: {message: 'Must be entered'}

##############################
  after_create :default_equips
  before_destroy :clear_ability_purchase

  scope :lvl1_evolves, -> { joins(:job).where('job')}

  def find_abil_purchases_in_socket(socket_num)
    ability_purchases.find_ability_purchases_for_socket(socket_num)
  end

  def self.base_mons(user)
    self.where(user_id: user).where(monster_id: Monster.base_mon.pluck(:id))
  end

  def abil_in_sock(socket_num, ability)
    if ability_purchases.find_by_socket_num(socket_num).ability == ability
      true
    else
      false
    end
  end

  def abil_purch_in_sock(socket_num)
    ability_purchases.find_by_socket_num(socket_num)
  end

  def abil_portrait(sock_num)
    abilities.abil_portrait(sock_num)
  end

  # def abil_img_in_sock(sock_num)
  #   abil_in_sock(sock_num).first.portrait.url(:small)
  # end

  # def abil_avail_for_sock(socket_num)
  #   self.abilities.where
  # end

  def self.unlock_check(user, monster_id)
    where(user_id: user, monster_id: monster_id)
  end

  def speech
    self.monster.thoughts.map(&:comment)
  end

  def mon_portrait(user)
    self.monster.monster_skin_equippings.where(user_id: user).first.monster_skin.portrait.url(:small)
  end

  def mon_skin(user)
    self.monster.monster_skin_equippings.where(user_id: user).first.monster_skin.avatar.url(:small)
  end

  def ap_cost
    self.monster.summon_cost
  end

  def name
    self.monster.name
  end

  def max_hp
    self.monster.max_hp
  end

  def hp
    self.monster.max_hp
  end

  def cost(index)
    self.abilities[index].ap_cost
  end

  def target(index)
    self.abilities[index].targeta
  end

  def image(user)
    self.monster.image(user)
  end

  def abdex(ability)
    self.monster.abilities.index(ability)
  end

  def evolve_animation
    self.monster.evolve_animation.url(:medium)
  end

  def unlocked_evolves

    def unlocked_monsters_ids
      MonsterUnlock.where(user_id: self.user_id).pluck(:monster_id)
    end

    def linked_evolution_ids
      self.monster.evolutions.where(id: unlocked_monsters_ids).pluck(:id)
    end

    return MonsterUnlock.where(user_id: self.user_id, monster_id: linked_evolution_ids)
  end

  def unlocked_evolved_from(user)
    def evolved_from_id
      self.monster.evolved_from.id
    end

    return MonsterUnlock.where(user_id: user, monster_id: evolved_from_id)
  end

  def mon_evols
    json_array    = []
    abil_array    = []
    effect_array  = []

    unlocked_evolves.each do |unlocked_evo|
      unlocked_evo.abilities.each do |ability|
        ability_hash = { name:        ability.name,
                         ap_cost:     ability.ap_cost,
                         stat_change: ability.stat_change,
                         description: ability.description,
                         stat:        ability.stat,
                         targeta:     ability.targeta,
                         elementa:    ability.elementa,
                         change:      ability.change,
                         description: ability.description,
                         modifier:    ability.modifier,
                         img:         ability.img,
                         slot:        ability.slot,
                         effects:     effect_array
                        }

        ability.effects.each do |effect|
          effect_hash = { name:        effect.name,
                          stat_change: effect.stat_change,
                          stat:        effect.stat,
                          targeta:     effect.targeta,
                          change:      effect.change,
                          modifier:    effect.modifier
                        }
          effect_array.push(effect_hash)
        end

        abil_array.push(ability_hash)
        effect_array = []
      end

      evolve_hash = { name:      unlocked_evo.name,
                      max_hp:    unlocked_evo.max_hp,
                      hp:        unlocked_evo.max_hp,
                      ap_cost:   unlocked_evo.ap_cost,
                      image:     unlocked_evo.image(self.user),
                      animation: unlocked_evo.evolve_animation,
                      abilities: abil_array,
                      portrait:  unlocked_evo.mon_portrait(self.user)
                    }

      json_array.push(evolve_hash)
      abil_array = []
    end

    return json_array
  end

  private

  def clear_ability_purchase
    self.ability_purchases.update_all(monster_unlock_id: 0)
  end

  def default_equips
    @monster_unlock_id  = self.id
    @monster_id         = self.monster_id
    @user_id            = self.user_id
    @default_sock1_id   = self.monster.default_sock1_id
    @default_sock2_id   = self.monster.default_sock2_id
    @default_skin_id    = self.monster.default_skin_id
    AbilityPurchase.on_monster_unlock(user_id: @user_id,
                                      abil_id: @default_sock1_id,
                                      monster_unlock_id: @monster_unlock_id
                                      )
    AbilityPurchase.on_monster_unlock(user_id: @user_id,
                                      abil_id: @default_sock2_id,
                                      monster_unlock_id: @monster_unlock_id
                                      )
    # MonsterSkinPurchase.on_monster_unlock(user_id: @user_id,
    #                                       mon_skin_id: @default_skin_id
    #                                       )
    MonsterSkinEquipping.create(monster_id: @monster_id, user_id: @user_id,
                                monster_skin_id: @default_skin_id
                                )
    if self.monster.rarity.name == "npc"
      @default_sock3_id = 18
      @default_sock4_id = 30

      AbilityPurchase.on_monster_unlock(user_id: @user_id,
                                        abil_id: @default_sock3_id,
                                        monster_unlock_id: @monster_unlock_id
                                        )
      AbilityPurchase.on_monster_unlock(user_id: @user_id,
                                        abil_id: @default_sock4_id,
                                        monster_unlock_id: @monster_unlock_id
                                        )
    else
    end
  end

end
