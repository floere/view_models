class ViewModels::SubSubclass < ViewModels::Subclass
  
  model_reader :some_untouched_attribute
  model_reader :some_filtered_attribute, :filter_through => :h
  model_reader :some_doubly_doubled_attribute, :filter_through => [:doubled]*2
  
  def h v
    CGI.escape v
  end
  
  def doubled text
    text*2
  end
  
end