module ViewModels
  # View model specific view.
  #
  class View < ActionView::Base
    
    # Shut up, opinionated funkers.
    #
    alias singleton_class metaclass unless instance_methods.include?('singleton_class')
    
    # Include the helpers from the view model.
    #
    def initialize controller, master_helper_module
      singleton_class.send :include, master_helper_module
      super controller.class.view_paths, {}, controller
    end
    
    #
    #
    def render_with options
      render options.to_render_options
    end
    
  end
end