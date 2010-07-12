# Base Module for ViewModels.
#
module ViewModels
  
  # Gets raised when render_as, render_the, or render_template cannot
  # find the named template, not even in the hierarchy.
  #
  class MissingTemplateError < StandardError; end
  
  # Base class from which all view_models inherit.
  #
  class Base
    
    # Model and Controller are accessible from outside.
    #
    # TODO but they actually shouldn't be. Try to migrate into protected area.
    #
    # TODO Rename controller => context, then alias context as controller.
    #
    attr_reader :model, :controller
    
    # Create a view_model. To create a view_model, you need to have a model (to present) and a context.
    # The context is usually a view, a controller, or an app, but doesn't need to be.
    # 
    def initialize model, context # TODO Rename to view_or_controller_or_app
      @model = model
      @controller = ControllerExtractor.new(context).extract # TODO Rename ContextExtractor
    end
      
  end
end