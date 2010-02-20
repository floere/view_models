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
    def render_for view_model_class, options
      path = view_model_class.render_path path_key(options), options
      template = find_template path
      # Could I directly render the template?
      #
      if template
        render options.merge! :file => template.path
      else
        render_for view_model_class.next, options
      end
    end
    
    # TODO
    #
    def find_template path
      view_paths.find_template path, template_format rescue nil
    end
    
    # TODO
    #
    def path_key options
      [options.name, template_format]
    end
    
  end
end