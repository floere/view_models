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
    # If it fails, it asks the next view_model_class for new render_options.
    #
    # Returns nil if there is no next view model class.
    #
    def render_for view_model_class, options
      template = view_model_class.template self, options
      
      render options.merge! :file => template.path
    end
    
    # Finds the template in the view paths at the given path, with its format.
    #
    def find_template path
      view_paths.find_template path, template_format rescue nil
    end
    
    # Return a "unique" key for the template.
    #
    def path_key name
      [name, template_format]
    end
    
  end
end