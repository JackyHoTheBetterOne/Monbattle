class User::Ascend
  include Virtus.model

  attribute :user, User
  attribute :selected_ascension
  attribute :monsters
  attribute :baby_monster
  attribute :bigger_monster
  attribute :enough
  attribute :first_time

  def call
    if MonsterUnlock.joins(:monster).
        where("user_id = ? AND monsters.evolved_from_id != ?", user.id, "0").length == 0
      self.first_time = true
    else
      self.first_time = false
    end


    mons = MonsterUnlock.includes(:monster).where(user_id: user.id)
    self.monsters = []
    owned_monster = []

    mons.each do |m|
      owned_monster << m.monster
    end

    mons.each do |m|
      if m.monster.evolutions.count != 0
        to_include = false
        m.monster.evolutions.each do |e|
          to_include = true if !owned_monster.include?e
        end
        self.monsters << m.monster if to_include == true
      end
    end

    if selected_ascension
      self.baby_monster = Monster.find_by_name(selected_ascension)
      self.bigger_monster = Monster.find_by_name(selected_ascension).evolutions[0]
      if user.summoner.asp >= bigger_monster.asp_cost
        self.enough = true
      else
        self.enough = false
      end
    end
  end
end