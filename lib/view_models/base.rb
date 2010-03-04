# Base Module for ViewModels.
#
module ViewModels
  
  # Base class from which all view_models inherit.
  #
  class Base
    
    # Model and Controller are accessible from outside.
    #
    # TODO but they actually shouldn't be. Try to migrate into protected area.
    #
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
      Renderer::Hierarchical.new(self, options).render_as name
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
      Renderer::Hierarchical.new(self, options).render_template name
    end
    
    # Returns a view instance for render_xxx.
    #
    def view_instance
      View.new controller, master_helper_module
    end
    
    attr_accessor :template_format
    
    protected
      
      # CaptureHelper needs this.
      #
      attr_accessor :output_buffer
      
  end
end