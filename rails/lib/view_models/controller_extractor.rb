# Base Module for ViewModels.
#
module ViewModels
  
  # Extracts controllers for a living from unsuspecting views.
  #
  class ControllerExtractor
    
    attr_reader :context
    
    def initialize context
      @context = context
    end
    
    # Extracts a controller from the context.
    #
    def extract
      context = self.context
      context.respond_to?(:controller) ? context.controller : context
    end
    
  end
  
end