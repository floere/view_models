class ViewModels::Test < ViewModels::Base
  helper ApplicationHelper
    
  def creation
    time_ago_in_words model.created_at
  end
  
end