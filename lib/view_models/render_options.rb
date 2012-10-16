module ViewModels
  
  # Container object for render options.
  # 
  module RenderOptions
    
    # Base class for Partial and Template.
    #
    class Base
      
      # The different attributes used to generate render options
      #
      attr_accessor :path, :name, :prefix, :file, :view_model, :format
      
      # Initialize Render Options
      # @param [String] prefix The prefix for rendering
      # @param [String] name The template name
      # @param [Hash] options The render options as a hash
      #
      def initialize prefix, name, options
        @prefix = prefix
        @options = options
        self.template_name = deoptionize name
        @format = @options.delete :format
      end
      
      # Generate a suitable error message for the error options.
      #
      def error_message
        "'#{error_path}#{name}' with #{error_format}"
      end
      
      # The error path, always returns a string
      # @return [String] The error path
      #
      def error_path
        path = self.path
        path ? "#{path}/" : ""
      end
      
      # The format when trying to render
      # @return [String] the render format
      #
      def error_format
        format = self.format
        format ? "format #{format}" : "default format"
      end
      
      # Used when rendering.
      # @return [Hash] The render options
      #
      def to_render_options
        @options[:locals] ||= {}
        @options[:locals].reverse_merge! :view_model => view_model
        @options.reverse_merge :file => file
      end
      
      # @todo Rails specific.
      # @param [ActionView] view The view to render
      #
      def format! view
        view.template_format = @format if @format
      end
      
      # Used for caching.
      #
      def path_key
        [self.path, self.name, self.format]
      end
      
      private
        
        # @todo rewrite
        #
        def template_name= template_name
          template_name.to_s.include?('/') ? specific_path(template_name) : incomplete_path(template_name)
        end
        
        # Specific path is a specifically named view path, with slashes.
        #
        def specific_path name
          self.path             = File.dirname name
          self.name_with_prefix = File.basename name
        end
        
        # Incomplete path is a view path without slashes. The view models will
        # try to find out where to take the template from.
        #
        def incomplete_path name
          self.path             = nil
          self.name_with_prefix = name
        end
        
        # Add the prefix to the template name.
        #
        # Note: Will add an underscore if it's a partial.
        #
        def name_with_prefix= name
          self.name = "#{self.prefix}#{name}"
        end
        
        # Extracts the template name from the given parameter.
        #
        # If it's a hash, it will remove and use the :partial option.
        # If not, it will use that.
        #
        def deoptionize template_name
          if template_name.kind_of?(Hash)
            @options.merge! template_name
            @options.delete :partial
          else
            template_name
          end
        end
        
      end
      
      # A specific container for partial rendering.
      #
      class Partial < Base
        def initialize name, options = {}
          super :'_', name, options
        end
      end

      # A specific container for template rendering.
      #
      class Template < Base
        def initialize name, options = {}
          super nil, name, options
        end
      end
    
  end
  
end