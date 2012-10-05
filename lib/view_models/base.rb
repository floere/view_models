# Base Module for ViewModels.
#
module ViewModels  
  # Gets raised when render_as, render_the, or render_template cannot
  # find the named template, not even in the hierarchy.
  #
  MissingTemplateError = Class.new(StandardError)
  
  # Base class from which all view_models inherit.
  #
  class Base
    
    # Make helper and helper_method available
    #
    include AbstractController::Helpers
    
    # Create a view_model. To create a view_model, you need to have a model (to present) and a context.
    # The context is usually a view, a controller, or an app, but doesn't need to be.
    # 
    #
    # The @context = @controller is really only needed because some Rails helpers access
    # @controller directly.
    # It's really bad.
    # @param [ActiveRecord] model The model which the view model is based upon
    # @param [ActionView, ActionController, Rails.application] app_or_controller_or_view The context of the view model
    # @todo Include this | Make it call super
    # @example Initialize a view model without the mapping helper
    #   ViewModel::YourModel.new(@model, @context)
    # 
    def initialize model, app_or_controller_or_view
      @model                 = model
      @context = @controller = ContextExtractor.new(app_or_controller_or_view).extract
    end
    
    class << self
      
      # Installs a path store, a specific store for
      # template inheritance, to remember specific
      # [path, name, format] tuples, pointing to a template path,
      # so the view models don't have to traverse the inheritance chain always.
      # @param [ViewModel] subclass The subclass of the view model
      #
      attr_accessor :path_store
      def inherited subclass
        ViewModels::PathStore.install_in subclass
        super
      end
      
      # Delegates method calls to the context.
      # In the view_model:
      #   self.current_user
      # will call
      #   context.current_user
      #
      # @params [Symbol] methods A list of symbols representing methods to be delegated
      # @example delegate one method to the context
      #   context_method :current_user
      # @example delegate multiple methods to the context
      #   context_method :current_user, :current_profile
      #
      def context_method *methods
        delegate *methods << { :to => :context }
      end
      
      # Alias the context_method to the rails-centric controller_method.
      #
      alias controller_method context_method
      
      # Installs the model_reader Method for filtered
      # model method delegation.
      #
      include Extensions::ModelReader
      
      # Wrapper for add_template_helper in ActionController::Helpers, also
      # includes given helper in the view_model
      #
      # @todo extract into module
      # @params [Module] helper_module the helper to be added
      #
      unless instance_methods.include?('old_add_template_helper')
        alias old_add_template_helper add_template_helper
        def add_template_helper helper_module
          include helper_module
          old_add_template_helper helper_module
        end
      end
      
      # Sets the view format and tries to render the given options.
      #
      # @note Also caches [path, name, format] => template path.
      #
      def render renderer, options
        options.format! renderer
        path_store.cached options do
          options.file = template_path renderer, options
          renderer.render_with options
        end
      end
      
      protected
        
        # Hierarchical rendering.
        #
        
        # Returns the next view model class in the render hierarchy.
        #
        # Note: Just returns the superclass.
        #
        # @todo Think about raising the MissingTemplateError here.
        # @returns The superclass of the view model, which ends with ViewModel::Base
        #
        def next_in_render_hierarchy
          superclass
        end
        
        # Raises the fitting template error with the given message
        # @params [String,Symbol] message The message with which the template error should be raised
        # @raises [MissingTemplateError] A template error indicating that the template is missing
        #
        def raise_template_error_with message
          raise MissingTemplateError.new("No template #{message} found.")
        end
        
        # Check if the view lookup inheritance chain has ended.
        # Raises a MissingTemplateError if yes.
        # @returns wether the current class is ViewModel::Base and therefore at the end of the inheritance chain
        #
        def inheritance_chain_ends?
           self == ViewModels::Base
        end
        
        # Template finding
        #
        
        # Returns a template path for the view with the given options.
        #
        # If no template is found, traverses up the inheritance chain.
        #
        # Raises a MissingTemplateError if none is found during
        # inheritance chain traversal.
        # @param 
        #
        def template_path renderer, options          
          raise_template_error_with options.error_message if inheritance_chain_ends?
          
          template_path_from(renderer, options) || self.next_in_render_hierarchy.template_path(renderer, options)
        end
        
        # ...        
        # Accesses the view to find a suitable template path.
        #
        def template_path_from renderer, options
          template = renderer.find_template tentative_template_path(options)
          
          template && template.virtual_path.to_s
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
        #   models/book
        #
        # Note: Remembers the result since it is dependent on the Class name only.
        #
        def view_model_path
          @view_model_path ||= self.name.gsub(/^ViewModels::|(\w+)(::)?/) { $1.underscore.pluralize + ($2 ? '/' : '').to_s if $1 }
        end
        
    end
        
    # Delegate context methods.
    #
    context_method :logger, :form_authenticity_token, :protect_against_forgery?, :request_forgery_protection_token, :config, :cookies, :flash, :default_url_options
    
    # id and param are simply delegated to the model.
    #
    # This makes it possible to use the view_model
    # for e.g. url generation:
    # * edit_user_path(view_model)
    #
    delegate :id, :to_param, :to => :model
    
    # Delegate dom id to the action controller record identifier.
    #
    def dom_id *args
      if args.present?
        context.dom_id *args
      else
        ActionController::RecordIdentifier.dom_id model
      end
    end
    
    # Make all the dynamically generated routes (restful routes etc.)
    # available in the view_model
    #
    Rails.application.routes.install_helpers self if Rails.application

    # include the helpers by default
    helper Helpers::View
    helper Helpers::Mapping
    
    # Renders the given partial in the view_model's view root in the format given.
    #
    # Example:
    #   views/view_models/this/view_model/_partial.haml
    #   views/view_models/this/view_model/_partial.text.erb
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
      render_internal RenderOptions::Partial.new(name, options)
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
    #   views/view_models/this/view_model/template.haml
    #   views/view_models/this/view_model/template name.text.erb
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
      render_internal RenderOptions::Template.new(name, options)
    end
    
    protected
      
      # Model and Context (Controller) are accessible from a view model.
      #
      # If you really need to call
      #   view_model.model.bla
      # in a view, I urge you to reconsider. But feel free to make
      # the methods model, controller, context public.
      #
      attr_reader :model, :context
      # CaptureHelper needs this.
      #
      attr_accessor :output_buffer
      
      
      alias controller context
      
      # Returns a view instance for render_xxx.
      #
      # TODO Try getting a view instance from the controller.
      #
      def renderer
        View.new context, self._helpers
      end
      
      # Internal render method that uses the options to get a view instance
      # and then referring to its class for rendering.
      #
      def render_internal options
        options.view_model = self
        
        determine_and_set_format options
                
        self.class.render renderer, options
      end
      
      # Determines what format to use for rendering.
      #
      # Note: Uses the template format of the view model instance
      #       if none is explicitly set in the options.
      #       This propagates the format to further render_xxx calls.
      #
      def determine_and_set_format options
        options.format = @template_format = options.format || @template_format
      end
  end
end