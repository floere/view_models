class ViewModels::Test < ViewModels::Base    
  include ViewModels::Extensions::ActiveRecord
  helper ViewModels::Helpers::View
  helper ViewModels::Helpers::Mapping
  helper ActionView::Helpers
  helper ApplicationHelper
    
  def creation
    time_ago_in_words model.created_at
  end
  
end