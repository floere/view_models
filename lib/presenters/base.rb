# Base Module for Presenters.
#
module Presenters
  
  # Base class from which all presenters inherit.
  #
  class Base
    attr_reader :model, :controller

    # A module that will collect all helpers that need to be made available to the view. 
    class_inheritable_accessor :master_helper_module
    self.master_helper_module = Module.new
  
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
      def model_reader(*args)
        args = args.dup
        opts = args.pop if args.last.kind_of?(Hash)
      
        fields = args.flatten
        filters = opts.nil? ? [] : [*(opts[:filter_through])].reverse
      
        fields.each do |field|
          reader = "def #{field}; 
                    #{filters.join('(').strip}(model.#{field})#{')' * (filters.size - 1) unless filters.empty?}; 
                    end"
          class_eval(reader)
        end
      end
    
      # Make a helper available to the current presenter, its subclasses and the presenter's views.
      #
      # Same as in Controller::Base.
      #
      def helper(helper)
        include helper
        master_helper_module.send(:include, helper)
      end
    
      # Delegates method calls to the controller.
      #
      # Example: 
      #   controller_method :current_user
      #
      # In the presenter:
      #   self.current_user
      # will call
      #   controller.current_user
      #
      def controller_method(*methods)
        methods.each do |method|
          delegate method, :to => :controller
        end
      end
    
      # Returns the path from the presenter_view_paths to the actual templates.
      # e.g. "presenters/models/book"
      #
      # If the class is named
      #   Presenters::Models::Book
      # this method will yield
      #   presenters/models/book
      #
      def presenter_path
        name.underscore
      end
    end # class << self
    
    # Create a presenter. To create a presenter, you need to have a model (to present) and a context.
    # The context is usually a view or a controller.
    # Note: But doesn't need to be one :)
    # 
    def initialize(model, context)
      @model = model
      @controller = extract_controller_from context
    end
    
    # Extracts a controller from the context.
    #
    def extract_controller_from(context)
      if context.respond_to?(:controller)
        context.controller
      else
        context
      end
    end
    
    # Make #logger available in presenters. 
    #
    controller_method :logger
    
    # Renders the given view in the presenter's view root in the format given.
    #
    # Example:
    #   app/views/presenters/this/presenter/template.html.haml
    #   app/views/presenters/this/presenter/template.text.erb
    #
    # Calling presenter.render_as('template', :html) will render the haml
    # template, calling presenter.render_as('template', :text) will render
    # the erb.
    #
    def render_as(view_name, format = nil)
      # Get a view instance from the view class.
      view = view_instance
    
      # Set the format to render in, e.g. :text, :html
      view.template_format = format if format
    
      # Finally, render and pass the presenter as a local variable.
      view.render :partial => template_path(view_name), :locals => { :presenter => self }
    end
    
    # Creates a view instance from the given view class.
    #
    def view_instance
      view = ActionView::Base.new(controller.class.view_paths, {}, controller)
      view.extend master_helper_module
    end
  
    # Returns the root of this presenters views with the template name appended.
    # e.g. 'presenters/some/specific/path/to/template'
    #
    def template_path(name)
      name = name.to_s
      if name.include?('/')    # Specific path like 'presenters/somethingorother/foo.haml' given.
        name
      else
        File.join(self.class.presenter_path, name)
      end
    end
  end
end