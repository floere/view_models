# Base Module for ViewModels.
#
module ViewModels
  
  # Base class from which all view_models inherit.
  #
  class Base
    attr_reader :model, :controller
    
    # Make helper and helper_method available
    #
    include ActionController::Helpers
    
    class << self
      
      # Define a reader for a model attribute. Acts as a filtered delegation to the model. 
      #
      # You may specify a :filter_through option that is either a symbol or an array of symbols. The return value
      # from the model will be filtered through the functions (arity 1) and then passed back to the receiver. 
      #
      # Example: 
      #
      #   model_reader :foobar                                        # same as delegate :foobar, :to => :model
      #   model_reader :foobar, :filter_through => :h                 # html escape foobar 
      #   model_reader :foobar, :filter_through => [:textilize, :h]   # first textilize, then html escape
      #
      def model_reader *fields
        options = extract_options_from fields
        filters = extract_filters_from options
        
        fields.each { |field| install_reader(field, filters) }
      end
      
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
      alias old_add_template_helper add_template_helper
      def add_template_helper helper_module
        include helper_module
        old_add_template_helper helper_module
      end
      
      # Tries to render the view.
      #
      # Note: I am not happy about using Exceptions as control flow.
      #       By caching partial paths successful renderings, we alleviate the problem.
      #
      def render view, name, options
        return if self == ViewModels::Base
        
        caching name, options do |options|
          begin
            view.render options
          rescue ActionView::MissingTemplate => missing_template
            superclass.render view, name, options
          end
        end
      end
      
      # Returns the root of this view_models views with the template name appended.
      # e.g. 'view_models/some/specific/path/to/template'
      #
      def template_path name
        name = name.to_s
        if name.include?('/') # Specific path like 'view_models/somethingorother/foo.haml' given.
          name
        else
          File.join view_model_path, name
        end
      end
      
      protected
        
        # Extract options hash from args array if there are any.
        # Returns nil if there are none.
        #
        # Note: Destructive.
        #
        def extract_options_from ary
          ary.pop if ary.last.kind_of?(Hash)
        end
        
        # Extract filter_through options from the options hash if there are any.
        #
        def extract_filters_from options
          options ? [*(options[:filter_through])].reverse : []
        end
        
        # Install a reader for the given name with the given filters.
        #
        # Example:
        # # Installs a reader for model.attribute which is first upcased, then h'd.
        # #
        # * install_reader :attribute, [:h, :upcase]
        #
        def install_reader name, filters
          class_eval reader_definition_for(name, filters)
        end
        
        # Defines a reader for the given model field and filtering
        # through the given filters, from right to left.
        # 
        # Note: The filters are applied from last to first element.
        #
        def reader_definition_for field, filters = []
          size              = filters.size
          left_parentheses  = filters.zip(['('] * size)
          right_parentheses = ')' * size
          "def #{field}; #{left_parentheses}model.#{field}#{right_parentheses}; end"
        end
        
        # Returns the path from the view_model_view_paths to the actual templates.
        # e.g. "view_models/models/book"
        #
        # If the class is named
        #   ViewModels::Models::Book
        # this method will yield
        #   view_models/models/book
        #
        # Note: Remembers the result.
        #
        def view_model_path
          @view_model_path || @view_model_path = self.name.underscore
        end
        
        # Caches partial names on successful rendering.
        #
        # Note: Caches only if something was rendered.
        #
        def caching name, options
          @name_partial_mapping ||= {}
          options[:partial] = @name_partial_mapping[name] || template_path(name)
          result = yield options
          @name_partial_mapping[name] ||= options[:partial] if result
          result
        end
        
    end # class << self
    
    # Create a view_model. To create a view_model, you need to have a model (to present) and a context.
    # The context is usually a view or a controller.
    # Note: But doesn't need to be one :)
    # 
    def initialize model, context
      @model = model
      @controller = extract_controller_from context
    end
    
    # Delegate controller methods.
    #
    controller_method :logger, :form_authenticity_token, :protect_against_forgery?, :request_forgery_protection_token
    
    # Make all the dynamically generated routes (restful routes etc.)
    # available in the view_model
    #
    ActionController::Routing::Routes.install_helpers self
    
    # Renders the given view in the view_model's view root in the format given.
    #
    # Example:
    #   app/views/view_models/this/view_model/template.html.haml
    #   app/views/view_models/this/view_model/template.text.erb
    #
    # The following options are supported: 
    # * :format - Calling view_model.render_as('template', :format => :html) will render the haml
    #   template, calling view_model.render_as('template', :format => :text) will render
    #   the erb.
    # * All other options are passed on to the render call. I.e. if you want to specify locals you can call
    #   view_model.render_as('template', :locals => { :name => :value })
    # * If no format is given, it will render the default format, which is (currently) html.
    #
    def render_as view_name, options = {}
      view = view_instance_for options.delete(:format)
      render view, view_name, options
    end
    
    protected
      
      # Sets up the options correctly and delegates to the class to actually render.
      #
      def render view, view_name, options
        options[:locals] = { :view_model => self }.merge options[:locals] || {}
        self.class.render view, view_name, options
      end
      
      # Creates a view instance with the given format.
      #
      # Examples:
      # * Calling view_instance_for :html will later render the haml
      #   template, calling view_instance_for :text will later render
      #   the erb.
      #
      def view_instance_for format
        view = view_instance
        view.template_format = format if format
        view
      end
      
      # Returns a view model view.
      #
      def view_instance
        ViewModels::View.new controller, master_helper_module
      end
      
      # Extracts a controller from the context.
      #
      def extract_controller_from context
        context.respond_to?(:controller) ? context.controller : context
      end
      
  end
end