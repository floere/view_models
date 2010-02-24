module ViewModels
  # View model specific view.
  #
  class View < ActionView::Base
    
    # Include the helpers from the view model.
    #
    def initialize controller, master_helper_module
      metaclass.send :include, master_helper_module
      super controller.class.view_paths, {}, controller
    end
    
    # This method tries to render with options obtained from the view model class.
    # 
    # It lets the view model class decide which template to use.
    #
    def render_for options
      render options.to_render_options
    end
    
    # Finds the template in the view paths at the given path, with its format.
    #
    def find_template path
      view_paths.find_template path, template_format rescue nil
    end
    
  end
end