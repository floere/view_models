module ViewModels
  # View model specific view.
  #
  class View < ActionView::Base
    
    attr_reader :view_model_class
    
    def initialize controller, master_helper_module
      metaclass.send :include, master_helper_module # unless included? master_helper_module
      super controller.class.view_paths, {}, controller
    end
    
    def render_as name, options
      options[:locals] = { :view_model => view_model }.merge options[:locals] || {}
      # check view model class for cached partial mapping - name
      render options
      # cache in view model class
    rescue ActionView::MissingTemplate => missing_template
      view_model_class = view_model_class.next_in_hierarchy and retry
    end
    
  end
end