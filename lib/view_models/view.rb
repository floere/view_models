module ViewModels
  # View model specific view.
  #
  class View < ActionView::Base
    
    def initialize controller, master_helper_module
      metaclass.send :include, master_helper_module # unless included? master_helper_module
      super controller.class.view_paths, {}, controller
    end
    
  end
end