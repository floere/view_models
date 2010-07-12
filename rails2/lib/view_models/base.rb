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
      alias context_method controller_method
      
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
      def render view, options
        options.format! view
        path_store.cached options do
          options.file = template_path view, options
          view.render_with options
        end
      end
      
      protected
        
        # Returns a template path for the view with the given options.
        #
        # If no template is found, traverses up the inheritance chain.
        #
        # Raises a MissingTemplateError if none is found during
        # inheritance chain traversal.
        #
        def template_path view, options
          raise_template_error_with options.error_message if inheritance_chain_ends?
          
          template_path_from(view, options) || self.next_in_render_hierarchy.template_path(view, options)
        end
        
        # Accesses the view to find a suitable template path.
        #
        def template_path_from view, options
          template = view.find_template tentative_template_path(options)
          
          template && template.path
        end
        
        # Return as render path either a stored path or a newly generated one.
        #
        # If nothing or nil is passed, the store is ignored.
        #
        def tentative_template_path options
          path_store[options.path_key] || generate_template_path_from(options)
        end
        
        # Returns the root of this view_models views with the template name appended.
        # e.g. 'view_models/some/specific/path/to/template'
        #
        def generate_template_path_from options
          File.join generate_path_from(options), options.name
        end
        
        # If the path is explicitly defined, return it, otherwise
        # generate a view model path from the class name.
        #
        def generate_path_from options
          options.path || view_model_path
        end
        
        # Returns the path from the view_model_view_paths to the actual templates.
        # e.g. "view_models/models/book"
        #
        # If the class is named
        #   ViewModels::Models::Book
        # this method will yield
        #   view_models/models/book
        #
        # Note: Remembers the result since it is dependent on the Class name only.
        #
        def view_model_path
          @view_model_path || @view_model_path = self.name.underscore
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
      
      # Rails specific render call.
      #
      def render options
        self.class.render view_instance, options
      end
      
      # Returns a view instance for render_xxx.
      #
      # TODO Try getting a view instance from the controller.
      #
      def view_instance
        # view = if controller.response.template
        #   controller.response.template
        # else
          View.new controller, master_helper_module
        # end
        
        # view.extend Extensions::View
      end
      
  end
end