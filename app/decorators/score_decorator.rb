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

  end

  def parent_level

  end




end
