class ViewModels::Item < ViewModels::Base
  
  helper ERB::Util
  helper ActionView::Helpers::TagHelper
  helper ActionView::Helpers::UrlHelper
  
  model_reader :name, :filter_through => :html_escape
  
  def header
    name
  end
  
end