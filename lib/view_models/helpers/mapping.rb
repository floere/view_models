module ViewModels
  module Helpers
    module Mapping
      
      # module attribute used for specific mapping
      #
      mattr_accessor :specific_view_model_mapping
      self.specific_view_model_mapping = {}
      
      # module attribute for the default view models prefix
      #
      mattr_accessor :default_prefix
      self.default_prefix = 'ViewModels::'
      
      # Create a new view_model instance for the given model instance
      # with the given arguments.
      # @raise [ArgumentError] if the view model class doesn't support 2 arguments.
      # @note context is either a view instance or a controller instance.
      #
      def view_model_for model, context = self
        view_model_class_for(model).new model, context
      end
      
      # Get the view_model class for the given model instance.
      #
      # @note ViewModels are usually of class ViewModels::<ModelClassName>. (As returned by default_view_model_class_for). Override specific_mapping if you'd like to install your own. Or Override default_view_model_class_for(model) if you'd like to change the default.
      #
      def view_model_class_for model
        specific_view_model_class_for(model) || default_view_model_class_for(model)
      end
      
      # Returns the default view_model class for the given model instance.
      #
      # Default class name is:
      # ViewModels::<ModelClassName>
      #
      # Override this method if you'd like to change the _default_
      # model-to-view_model class mapping.
      #
      # @raise [NameError] if a corresponding ViewModels constant cannot be loaded.
      #
      def default_view_model_class_for model
        (default_prefix + model.class.name).constantize
      end
      
      # Returns a specific view_model class for the given model instance.
      #
      # Override this method, if you want to return a specific
      # view model class for the given model.
      #
      # @raise [NameError] if a corresponding ViewModels constant cannot be loaded.
      #
      def specific_view_model_class_for model
        specific_view_model_mapping[model.class]
      end
      
    end
  end
end
