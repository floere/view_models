class ViewModels::Item < ViewModels::Base
  
  register ERB::Util
  
  model_reader :name, :filter_through => :html_escape
  
  def header
    name
  end
  
end