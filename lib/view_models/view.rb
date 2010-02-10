module ViewModels
  class View < ActionView::Base
    
    def initialize controller, master_helper_module
      view = super controller.class.view_paths, {}, controller
      view.extend master_helper_module
    end
    
  end
end