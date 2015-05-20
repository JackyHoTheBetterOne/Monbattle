class MonsterDecorator
  attr_reader :monster
  attr_reader :skin

  def initialize(monster)
    @monster = monster
    @skin = MonsterSkin.find(@monster.default_skin_id)
  end

  def self.collection(monsters)
    monster_collection = []
    monsters.each do |g|
      monster_collection << self.new(g)
    end
    return monster_collection
  end

  def avatar
    @skin.portrait.url(:thumb)
  end

  def skin
    @skin.avatar
  end

  def designer
    @monster.default_skin_id ? @skin.painter : "Frank Yan"
  end

  def rarity_type
    @monster.rarity ? @monster.rarity.name : ""
  end

  def job_type
    @monster.job ? @monster.job.name : ""
  end

  def css_display_difference(current_user)
    MonsterUnlock.where("user_id = #{current_user.id} AND monster_id = #{@monster.id}").pluck(:id).length > 0 ? 
      "opacity: 1;" : "opacity: 0.3; cursor: default;"
  end




  def method_missing(method_name, *args, &block)
    monster.send(method_name, *args, &block)
  end

  def respond_to_missing?(method_name, include_private = false)
    monster.respond_to?(method_name, include_private) || super
  end 

end