class Book < Item
  
  attr_reader :pages
  
  def initialize name, pages
    @pages = pages
    super name
  end
  
end
