class User::Ascend
  include Virtus.model

  attribute :user, User
  attribute :selected_ascension
  attribute :monsters
  attribute :baby_monster
  attribute :bigger_monster

  def call
    mons = MonsterUnlock.includes(:monster).where(user_id: user.id)
    self.monsters = []

    mons.each do |m|
      if m.monster.evolutions.count != 0
        self.monsters << m.monster
      end
    end

    if selected_ascension
      self.baby_monster = Monster.find_by_name(selected_ascension)
      self.bigger_monster = Monster.find_by_name(selected_ascension).evolutions[0]
    end
  end
end