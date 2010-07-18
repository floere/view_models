# Base Module for ViewModels.
#
module ViewModels
  
  # Extracts controllers for a living from unsuspecting views.
  #
  # Note: This is actually only needed in Rails. In Padrino, the context is always the app.
  #
  class ContextExtractor
    
    attr_reader :context
    
    def initialize context
      @context = context
    end
    
    # Extracts a controller from the context.
    #
    def extract
      context = self.context
      context.respond_to?(:controller) ? context.send(:controller) : context
    end
    
  end
  
end