# # takes 2 inputs and does mathimatical operations to them

class MathMaster
  def initialize(input1,input2)
    @input1 = input1
    @input2 = input2
  end

  def adder
     return @input1 + @input2
  end

  # def multiplier
  #   return @input1 * @input2
  # end

end

puts "Enter 2 numbers seperated by a comma"
a = gets.chomp.split(",")

numbers = MathMaster.new(a[0],a[1])
numbers.adder
#numbers.multiplier









