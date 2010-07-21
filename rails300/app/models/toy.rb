class Toy < Item
  
  attr_reader :ages
  
  def initialize name, ages
    @ages = ages
    super name
  end
  
end
