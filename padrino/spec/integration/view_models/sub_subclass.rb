class ViewModels::SubSubclass < ViewModels::Subclass
  
  controller_method :logger
  
  model_reader :some_untouched_attribute
  model_reader :some_filtered_attribute, :filter_through => :h
  model_reader :some_doubly_doubled_attribute, :filter_through => [:doubled]*2
  model_reader :some_mangled_attribute, :filter_through => [:reverse, :cutoff, :doubled, :upcase]
  
  # h as we know it.
  #
  def h v
    CGI.escape v
  end
  
  # Multiplies the text by 2.
  #
  def doubled text
    text*2
  end
  
  # Cuts off the last 2 characters. Or all, if less than size 2.
  #
  def cutoff text
    text[0..-2]
  end
  
  def reverse text
    text.reverse
  end
  
  def upcase text
    text.upcase
  end
  
  # Captures the block as a string.
  #
  def capture_block &block
    capture &block
  end
  
end