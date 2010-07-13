# Base Module for ViewModels.
#
module ViewModels
  
  # Base class from which all view_models inherit.
  #
  class Base
    
    # Make helper and helper_method available
    #
    include ActionController::Helpers
    
    class << self
      
      # Installs a path store, a specific store for
      # template inheritance, to remember specific
      # [path, name, format] tuples, pointing to a template path,
      # so the view models don't have to traverse the inheritance chain always.
      #
      # Note: Only needed in Rails.
      #
      attr_accessor :path_store
      def inherited subclass
        ViewModels::PathStore.install_in subclass
        super
      end
      
      # Alias the context_method to the rails-centric controller_method.
      #
      alias controller_method context_method
      
      # Wrapper for add_template_helper in ActionController::Helpers, also
      # includes given helper in the view_model
      #
      # TODO extract into module
      #
      alias old_add_template_helper add_template_helper
      def add_template_helper helper_module
        include helper_module
        old_add_template_helper helper_module
      end
      
      # Sets the view format and tries to render the given options.
      #
      # Note: Also caches [path, name, format] => template path.
      #
      def render renderer, options
        options.format! renderer
        path_store.cached options do
          options.file = template_path renderer, options
          renderer.render_with options
        end
      end
      
      protected
        
        # Accesses the view to find a suitable template path.
        #
        def template_path_from renderer, options
          template = renderer.find_template tentative_template_path(options)
          
          template && template.path
        end
        
        # Return as render path either a stored path or a newly generated one.
        #
        # If nothing or nil is passed, the store is ignored.
        #
        def tentative_template_path options
          path_store[options.path_key] || generate_template_path_from(options)
        end
        
    end # class << self
    
    # Delegate context methods.
    #
    context_method :form_authenticity_token, :protect_against_forgery?, :request_forgery_protection_token
    
    # Make all the dynamically generated routes (restful routes etc.)
    # available in the view_model
    #
    ActionController::Routing::Routes.install_helpers self
    
    protected
      
      alias controller context
      
      # CaptureHelper needs this.
      #
      attr_accessor :output_buffer
      
      # Returns a view instance for render_xxx.
      #
      # TODO Try getting a view instance from the controller.
      #
      def renderer
        # view = if controller.response.template
        #   controller.response.template
        # else
          View.new controller, master_helper_module
        # end
        
        # view.extend Extensions::View
      end
      
  end
end