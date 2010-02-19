class ViewModels::SubSubclass < ViewModels::Subclass
  
  controller_method :logger
  
  model_reader :some_untouched_attribute
  model_reader :some_filtered_attribute, :filter_through => :h
  model_reader :some_doubly_doubled_attribute, :filter_through => [:doubled]*2
  model_reader :some_mangled_attribute, :filter_through => [:reverse, :cutoff, :doubled, :upcase]
  
  def h v
    CGI.escape v
  end
  
  def doubled text
    text*2
  end
  
  def cutoff text
    text[0..-2]
  end
  
  def reverse text
    text.reverse
  end
  
  def upcase text
    text.upcase
  end
  
  def capture_in_method &block
    capture &block
  end
  
end