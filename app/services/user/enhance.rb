class User::Enhance
  include Virtus.model

  attribute :user, User
  attribute :monsters
  attribute :selected
  attribute :monster
  attribute :enough
  attribute :max_level
  attribute :owned_evo
  attribute :evo_name


  def call
    mons = MonsterUnlock.where(user_id: user.id)
    self.monsters = []

    mons.each do |m|
      self.monsters << m if m.level <= m.monster.max_level && m.monster.evolved_from_id == 0
    end

    if selected
      monster_id = Monster.find_by_name(selected)
      self.monster = MonsterUnlock.where(user_id: user.id, monster_id: monster_id)[0]

      if user.summoner.enh >= 10 && user.summoner.gp >= 50
        self.enough = true
      else
        self.enough = false
      end

      if monster.level == monster.monster.max_level
        self.max_level = true
      else
        self.max_level = false
      end



      if self.monster.monster.evolutions[0]
        monster_id = self.monster.monster.evolutions[0].id
      else
        monster_id = "nothing"
      end

      evol_array = MonsterUnlock.where(user_id: user.id, monster_id: monster_id)

      if evol_array.length == 0
        self.owned_evo = false
      else
        self.owned_evo = true
        self.evo_name = evol_array[0].name
      end

    end
  end
end