class ScoreDecorator 
  attr_reader :score

  def initialize(score)
    @score = score
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

  def method_missing(method_name, *args, &block)
    score.send(method_name, *args, &block)
  end

  def respond_to_missing?(method_name, include_private = false)
    score.respond_to?(method_name, include_private) || super
  end 


end
