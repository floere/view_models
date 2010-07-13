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
        # path_store.cached options do
          # options.file = template_path renderer, options
          # view.render_with options
          path = template_path renderer, options
          # options.to_render_options
          # renderer.send :render, :erb, path.to_s, options.locals
          renderer.instance_variable_set(:@_content_type, options.format) if options.format
          
          options = options.to_render_options
          
          renderer.send :render, path.to_s, options
        # end
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
          template && template.first # was .path
        rescue Padrino::Rendering::TemplateNotFound => t
          nil
        end
        
        # Return as render path either a stored path or a newly generated one.
        #
        # If nothing or nil is passed, the store is ignored.
        #
        def tentative_template_path options
          # TODO Use Padrino template cache!
          # path_store[options.path_key] || generate_template_path_from(options)
          generate_template_path_from options
        end
        
    end
    
    alias app context
    
    protected
      
      def renderer
        app
      end
      
  end
end