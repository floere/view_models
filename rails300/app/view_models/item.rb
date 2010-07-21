class ViewModels::Item < ViewModels::Base
  
  helper ERB::Util
  helper ActionView::Helpers::TagHelper # Needed for the UrlHelper
  helper ActionView::Helpers::UrlHelper # Needed for url_for 
  
  model_reader :name, :filter_through => :html_escape
  
  def header
    name
  end
  
end