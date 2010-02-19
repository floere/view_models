module ViewModels
  # View model specific view.
  #
  class View < ActionView::Base
    
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
    # Note: I am not terribly happy about using Exceptions as control flow.
    #
    def render_for view_model_class, name, options # view_model_class, options
      path = view_model_class.render_path name, options
      template = find_template path
      # Could I directly render the template?
      #
      if template
        render options.merge! :file => template.path
      else
        render_for view_model_class.next, name, options
      end
    end
    
    #
    #
    def find_template path
      view_paths.find_template path, template_format rescue nil
    end
    
  end
end