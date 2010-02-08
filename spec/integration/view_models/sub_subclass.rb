class ViewModels::SubSubclass < ViewModels::Subclass
  
  model_reader :some_untouched_attribute
  model_reader :some_filtered_attribute, :filter_through => :h
  
  def h v
    CGI.escape v
  end
  
end