# Base Module for ViewModels.
#
module ViewModels
  
  # Gets raised when render_as, render_the, or render_template cannot
  # find the named template, not even in the hierarchy.
  #
  class MissingTemplateError < StandardError; end
  
  # Base class from which all view_models inherit.
  #
  class Base
    
    attr_reader :model, :controller
    
    # Make helper and helper_method available
    #
    include ActionController::Helpers
    
    # Create a view_model. To create a view_model, you need to have a model (to present) and a context.
    # The context is usually a view or a controller, but doesn't need to be.
    # 
    def initialize model, context
      @model = model
      @controller = ControllerExtractor.new(context).extract
    end
    
    class << self
      
      # Installs a path store, a specific store for
      # template inheritance, to remember specific
      # [path, name, format] tuples, pointing to a template path,
      # so the view models don't have to traverse the inheritance chain always.
      #
      attr_accessor :path_store
      def inherited subclass
        ViewModels::PathStore.install_in subclass
        super
      end
      
      # Installs the model_reader Method for filtered
      # model method delegation.
      #
      include Extensions::ModelReader
      
      # Delegates method calls to the controller.
      #
      # Examples:
      #   controller_method :current_user
      #   controller_method :current_user, :current_profile  # multiple methods to be delegated
      #
      # In the view_model:
      #   self.current_user
      # will call
      #   controller.current_user
      #
      def controller_method *methods
        delegate *methods << { :to => :controller }
      end
      
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
      
      # Returns a template path for the view with the given options.
      #
      # If no template is found, traverses up the inheritance chain.
      #
      # Raises a MissingTemplateError if none is found during
      # inheritance chain traversal.
      #
      def template_path view, options
        raise_template_error_with options.error_message if inheritance_chain_ends?
        
        template = view.find_template tentative_template_path(options)
        
        template && template.path || self.next.template_path(view, options)
      end
      
      protected
        
        # Returns the next view model class in the render hierarchy.
        #
        # Note: Just returns the superclass.
        #
        # TODO Think about raising the MissingTemplateError here.
        #
        def next
          superclass
        end
        
        # Just raises a fitting template error.
        #
        def raise_template_error_with message
          raise MissingTemplateError.new "No template #{message} found."
        end
        
        # Check if the view lookup inheritance chain has ended.
        #
        # Raises a MissingTemplateError if yes.
        #
        def inheritance_chain_ends?
           self == ViewModels::Base
        end
        
        # Return as render path either a stored path or a newly generated one.
        #
        # If nothing or nil is passed, the store is ignored.
        #
        # TODO How or why can path_store be nil?
        #
        def tentative_template_path options
          path_store && path_store[options.path_key] || generate_template_path_from(options)
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
    
    # Delegate controller methods.
    #
    controller_method :logger, :form_authenticity_token, :protect_against_forgery?, :request_forgery_protection_token
    
    # Make all the dynamically generated routes (restful routes etc.)
    # available in the view_model
    #
    ActionController::Routing::Routes.install_helpers self
    
    # Renders the given partial in the view_model's view root in the format given.
    #
    # Example:
    #   app/views/view_models/this/view_model/_partial.haml
    #   app/views/view_models/this/view_model/_partial.text.erb
    #
    # The following options are supported: 
    # * :format - Calling view_model.render_as('partial') will render the haml
    #   partial, calling view_model.render_as('partial', :format => :text) will render
    #   the text erb.
    # * All other options are passed on to the render call. I.e. if you want to specify locals you can call
    #   view_model.render_as(:partial, :locals => { :name => :value })
    # * If no format is given, it will render the default format, which is (currently) html.
    #
    def render_as name, options = {}
      render RenderOptions::Partial.new(name, options)
    end
    # render_the is used for small parts.
    #
    # Example:
    # # If the view_model is called window, the following
    # # is more legible than window.render_as :menubar
    # * window.render_the :menubar
    #
    alias render_the render_as
    
    # Renders the given template in the view_model's view root in the format given.
    #
    # Example:
    #   app/views/view_models/this/view_model/template.haml
    #   app/views/view_models/this/view_model/template name.text.erb
    #
    # The following options are supported: 
    # * :format - Calling view_model.render_template('template') will render the haml
    #   template, calling view_model.render_template('template', :format => :text) will render
    #   the text erb template.
    # * All other options are passed on to the render call. I.e. if you want to specify locals you can call
    #   view_model.render_template(:template, :locals => { :name => :value })
    # * If no format is given, it will render the default format, which is (currently) html.
    #
    def render_template name, options = {}
      render RenderOptions::Template.new(name, options)
    end
    
    protected
      
      # Internal render method that uses the options to get a view instance
      # and then referring to its class for rendering.
      #
      def render options
        options.view_model = self
        
        determine_format options
        
        self.class.render view_instance, options
      end
      
      # Returns a view instance for render_xxx.
      #
      # TODO Try getting a view instance from the controller.
      #
      def view_instance
        View.new controller, master_helper_module
      end
      
      # Determines what format to use for rendering.
      #
      # Note: Uses the template format of the view model instance
      #       if none is explicitly set in the options.
      #       This propagates the format to further render_xxx calls.
      #
      def determine_format options
        options.format = @template_format = options.format || @template_format
      end
      
  end
end