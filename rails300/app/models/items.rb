class Items
  
  def self.all
    [
      Book.new('Some Title', 123),
      Toy.new('Some Toy', 9),
      Book.new('Some other Title', 555),
      Toy.new('Some other Toy', 12),
      Toy.new('Yet another Toy', 4)
    ]
  end
  
end