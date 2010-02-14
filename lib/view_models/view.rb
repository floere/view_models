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
      options = options.merge :partial => view_model_class.partial_path(name)
      render options
    rescue ActionView::MissingTemplate => missing_template
      view_model_class = view_model_class.next and retry
    end
    
  end
end