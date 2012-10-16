# Base Module for ViewModels.
#
module ViewModels
  
  # Extracts controllers for a living from unsuspecting views.
  #
  class ContextExtractor
    
    # The context
    #
    attr_reader :context
    
    # Initialize the Context extractor
    # @param [ActionController, ActionMailer, ActionView] context Some render context
    #
    def initialize context
      @context = context
    end
    
    # Extracts a controller from the context.
    # @return [ActionController] an instance of action controller
    #
    def extract
      context = self.context
      context.respond_to?(:controller) ? context.send(:controller) : context
    end
    
  end
  
end