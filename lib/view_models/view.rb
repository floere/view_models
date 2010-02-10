module ViewModels
  class View < ActionView::Base
    
    def initialize controller, master_helper_module
      (class << self; self; end).send :include, master_helper_module
      super controller.class.view_paths, {}, controller
    end
    
  end
end