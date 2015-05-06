class EventTierPrice
  attr_accessor :type
  attr_accessor :id

  def initialize(options = {})
    begin 
      object = Object.const_get(options[:type]).find(options[:id])
    rescue
      object = nil
      warn "Cannot find the reward. Object cannot be created."
    end
    if object
      @type = options[:type]
      @id = options[:id]
    end
  end
end