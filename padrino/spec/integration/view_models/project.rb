class ViewModels::Project < ViewModels::Base
  
  helper :all
  
  # helper ActionView::Helpers::CaptureHelper
  
  helper ViewModels::Helpers::Rails
  helper ViewModels::Helpers::View
  
  # def output_buffer= b
  #   view.output_buffer = b
  # end
  
end