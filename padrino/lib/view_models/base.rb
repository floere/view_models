# Base Module for ViewModels.
#
module ViewModels
  
  # Base class from which all view_models inherit.
  #
  class Base
    
    # Make helper and helper_method available
    #
    # include ActionController::Helpers
    
    class << self
      
      # Alias the context_method to the padrino-centric app_method.
      #
      alias app_method context_method
      
    end
    
    alias app context
    
    protected
      
      # Padrino specific render call.
      #
      def render options
        app.send :render, *options.to_padrino_render_params
      end
      
  end
end