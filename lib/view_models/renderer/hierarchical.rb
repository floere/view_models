module ViewModels
  
  module Renderer
    
    # Gets raised when render_as, render_the, or render_template cannot
    # find the named template, not even in the hierarchy.
    #
    class MissingTemplateError < StandardError; end
    
    # This class handles hierarchical rendering.
    #
    # Note: The render_as, render_the, render_template on the view model.
    #
    # Traverses the ancestors chain, and accesses the path store of
    # the view model classes and included modules.
    #
    class Hierarchical
      
      metaclass.send :attr_accessor, :path_store
      PathStore.install_in self
      
      attr_reader :view_model, :options, :current_class
      
      def initialize view_model, options
        @view_model       = view_model
        @options          = options
      end
      
      def render_as name
        @options = RenderOptions::Partial.new name, @options
        prepare_and_render
      end
      
      def render_template name
        @options = RenderOptions::Template.new name, @options
        prepare_and_render
      end
      
      # Sets the view format and tries to render the given options.
      #
      # Note: Also caches [path, name, format] => template path.
      #
      def render
        @options.format! @view_instance
        path_store.cached @current_class, @options do
          @options.file = template_path
          @view_instance.render_with @options
        end
      end
      
      # Returns the next view model class in the render hierarchy.
      #
      # Note: Just returns the superclass.
      #
      # TODO Think about raising the MissingTemplateError here.
      #
      def next_in_render_hierarchy
        @current_class = @render_hierarchy.shift
      end
      
      # Just raises a fitting template error.
      #
      def raise_template_error
        raise MissingTemplateError.new "No template #{@options.error_message} found."
      end
      
      # Check if the view lookup inheritance chain has ended.
      #
      # Raises a MissingTemplateError if yes.
      #
      def inheritance_chain_ends?
         @current_class == ViewModels::Base
      end
      
      # Returns a template path for the view with the given options.
      #
      # If no template is found, traverses up the inheritance chain.
      #
      # Raises a MissingTemplateError if none is found during
      # inheritance chain traversal.
      #
      def template_path
        raise_template_error if inheritance_chain_ends?
        
        template_path_from_view_instance || next_in_render_hierarchy && template_path
      end
      
      # Accesses the view to find a suitable template path.
      #
      def template_path_from_view_instance
        template = @view_instance.find_template tentative_template_path
        
        template && template.path
      end
      
      # Return as render path either a stored path or a newly generated one.
      #
      # If nothing or nil is passed, the store is ignored.
      #
      def tentative_template_path
        path_store[@options.path_key(@current_class)] || generate_template_path
      end
      
      # Returns the root of this view_models views with the template name appended.
      # e.g. 'view_models/some/specific/path/to/template'
      #
      def generate_template_path
        File.join generate_path, @options.name
      end
      
      # If the path is explicitly defined, return it, otherwise
      # generate a view model path from the class name.
      #
      def generate_path
        @options.path || view_model_path
      end
      
      #
      #
      def view_model_path
        @current_class.name.underscore
      end
      
      # Internal render method that uses the options to get a view instance
      # and then referring to its class for rendering.
      #
      def prepare_and_render
        @options.view_model = @view_model
        
        determine_and_set_format @options
        
        @view_instance = @view_model.view_instance
        @render_hierarchy = render_hierarchy
        @current_class = next_in_render_hierarchy
        
        render
      end
      
      #
      #
      def render_hierarchy
        @view_model.class.ancestors
      end
      
      # Determines what format to use for rendering.
      #
      # Note: Uses the template format of the view model instance
      #       if none is explicitly set in the options.
      #       This propagates the format to further render_xxx calls.
      #
      def determine_and_set_format options
        options.format = @view_model.template_format = options.format || @view_model.template_format
      end
      
      def path_store
        self.class.path_store
      end
      
    end
    
  end
  
end