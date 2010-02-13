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
    # If the next view_model_class does not return
    #
    # Returns nil if there is no next renderer
    # 
    def render_for view_model_class, name
      return unless options = view_model_class.render_options(name)
      render options
    rescue ActionView::MissingTemplate => missing_template
      view_model_class = view_model_class.next_renderer and retry
    end
    
  end
end