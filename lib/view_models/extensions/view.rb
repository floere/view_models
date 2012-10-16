# Not used at the moment
#
# Extends a standard ActionView::Base view with methods
# needed by the view models.
#
module ViewModels
  module Extensions
    
    # Extensions for the View instance
    #
    module View
      
      # Renders the template with the given options
      # @param [RenderOptions::Base] options The options to render with
      #
      def render_with options
        render options.to_render_options
      end

      # Finds the template in the view paths at the given path, with its format.
      # @param [String] path the template path
      #
      def find_template path
        view_paths.find_template path, template_format rescue nil
      end
      
    end
  end
end