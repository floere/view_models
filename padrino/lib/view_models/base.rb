# Base Module for ViewModels.
#
module ViewModels
  
  # Base class from which all view_models inherit.
  #
  class Base
    
    # Make helper and helper_method available
    #
    # include ActionController::Helpers
    
    class << self
      
      # Alias the context_method to the padrino-centric app_method.
      #
      alias app_method context_method
      
      # Sets the view format and tries to render the given options.
      #
      # Note: Also caches [path, name, format] => template path.
      #
      def render renderer, options
        # options.format! view
        renderer.instance_variable_set(:@_content_type, options.format || :html)
        path_store.cached options do
          path = template_path renderer, options
          options.file = path
          renderer.send :render, path.to_s, options.to_render_options
        end
      end
      
      protected
        
        # Accesses the view to find a suitable template path.
        #
        # Returns nil if a template cannot be found.
        #
        def template_path_from renderer, options
          template = renderer.send :resolve_template, tentative_template_path(options)
          # TODO!
          #
          template && template.first.to_s # was .path
        rescue Padrino::Rendering::TemplateNotFound => t
          nil
        end
        
    end
    
    alias app context
    
    protected
      
      def renderer
        app
      end
      
  end
end