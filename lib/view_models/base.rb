# Base Module for ViewModels.
#
module ViewModels
  
  class MissingTemplateError < StandardError; end
  
  # Base class from which all view_models inherit.
  #
  class Base
    
    attr_accessor :format
    attr_reader   :model, :controller
    
    # Make helper and helper_method available
    #
    include ActionController::Helpers
    
    # Create a view_model. To create a view_model, you need to have a model (to present) and a context.
    # The context is usually a view or a controller.
    # Note: But doesn't need to be one :)
    # 
    def initialize model, context
      @model = model
      @controller = extract_controller_from context
    end
    
    class << self
      
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
      alias old_add_template_helper add_template_helper
      def add_template_helper helper_module
        include helper_module
        old_add_template_helper helper_module
      end
      
      # Returns the next view model class in the render hierarchy.
      #
      def next
        raise MissingTemplateError.new if self == ViewModels::Base
        superclass
      end
      
      #
      #
      def render_as view, name, options
        result = view.render_for self, name, options
        save_successful_render name, options if result
        result
      end
      
      # Returns the root of this view_models views with the template name appended.
      # e.g. 'view_models/some/specific/path/to/template'
      #
      def template_path name, options
        name = name.to_s
        if name.include?('/') # Specific path like 'view_models/somethingorother/foo.haml' given.
          name
        else
          File.join view_model_path, "#{options[:prefix]}#{name}"
        end
      end
      
      # The view gets its TODO
      #
      def render_path name, options
        @name_partial_mapping ||= {} # rewrite
        @name_partial_mapping[name] || template_path(name, options) # TODO rewrite
      end
      def save_successful_render name, options
        @name_partial_mapping ||= {} # rewrite
        @name_partial_mapping[name] ||= options[:partial]
      end
      
      protected
        
        # Returns the path from the view_model_view_paths to the actual templates.
        # e.g. "view_models/models/book"
        #
        # If the class is named
        #   ViewModels::Models::Book
        # this method will yield
        #   view_models/models/book
        #
        # Note: Remembers the result.
        # TODO Use memoize?
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
    
    # Renders the given view in the view_model's view root in the format given.
    #
    # Example:
    #   app/views/view_models/this/view_model/_partial.haml
    #   app/views/view_models/this/view_model/_partial.text.erb
    #
    # The following options are supported: 
    # * :format - Calling view_model.render_as('template') will render the haml
    #   partial, calling view_model.render_as('template', :format => :text) will render
    #   the text erb.
    # * All other options are passed on to the render call. I.e. if you want to specify locals you can call
    #   view_model.render_as(:partial, :locals => { :name => :value })
    # * If no format is given, it will render the default format, which is (currently) html.
    #
    def render_as name, options = {}
      # options = name and name = options.delete(:partial) if name.kind_of?(Hash)
      options[:prefix] = :'_'
      render name, options
    end
    # render_the is used for small parts.
    #
    # Example:
    # # If the view_model is called window, the following
    # # is more legible than window.render_as :menubar
    # * window.render_the :menubar
    #
    alias render_the render_as
    
    def render_template name, options = {}
      options[:prefix] = nil
      render name, options
    end
    
    protected
      
      attr_accessor :template_format
      
      def render name, options
        options[:locals] = { :view_model => self }.merge options[:locals] || {}
        view = View.new controller, master_helper_module
        if self.template_format = options.delete(:format) || self.template_format
          view.template_format = self.template_format
        end
        # metaclass.send :define_method, :output_buffer= do |buffer|
        #   view.output_buffer = buffer
        # end
        # metaclass.send :define_method, :output_buffer do |buffer|
        #   view.output_buffer = buffer
        # end
        self.class.render_as view, name, options
      end
      
      # # Creates a view instance with the given format.
      # #
      # # Examples:
      # # * Calling view_instance_for :html will later render the haml
      # #   template, calling view_instance_for :text will later render
      # #   the erb.
      # #
      # def view_instance_for format
      #   view = View.new controller, master_helper_module
      #   view.template_format = format if format
      #   view
      # end
      
      # Extracts a controller from the context.
      #
      def extract_controller_from context
        context.respond_to?(:controller) ? context.controller : context
      end
      
  end
end