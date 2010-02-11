module ViewModels
  # View model specific view.
  #
  class View < ActionView::Base
    
    def initialize controller, master_helper_module
      metaclass.send :include, master_helper_module # unless included? master_helper_module
      super controller.class.view_paths, {}, controller
    end
    
    def render_view_model view_model, name, options
      options[:locals] = { :view_model => view_model }.merge options[:locals] || {}
      # self.class.render view, view_name, options
    end
    
  end
end