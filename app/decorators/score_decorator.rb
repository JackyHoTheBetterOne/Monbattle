class ScoreDecorator 
  attr_reader :score
  attr_reader :area

  def initialize(score)
    @score = score
    @area = score.area
  end

  def self.collection(scores)
    score_collection = []
    scores.each do |s|
      score_collection << self.new(s)
    end
    return score_collection
  end

  def parent_name
    @score.scorapable.name
  end

  def parent_level
    @score.scorapable.level
  end

  def guild_name
    if @score.scorapable_type == "Summoner"
      return @score.scorapable.guild.name
    else
      return ""
    end
  end


  def rank(summoner_id)
    if @score.scorapable_type == "Guild"
      Score.guild_scores(@area.name).pluck(:id).index(@score.id) + 1
    else
      Score.individual_scores(@area.name).pluck(:id).index(@score.id) + 1
    end
  end


  def leadership_border(current_object)
    if current_object.name == @score.scorapable.name
      return 'border: 1px solid yellow'
    else  
      return ''
    end
  end



  def method_missing(method_name, *args, &block)
    score.send(method_name, *args, &block)
  end

  def respond_to_missing?(method_name, include_private = false)
    score.respond_to?(method_name, include_private) || super
  end 


end
