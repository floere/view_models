# Base Module for ViewModels.
#
module ViewModels
  
  # A simple path store. Designed to remove a bit of complexity from the base view model.
  #
  # Use it to install an instance in the metaclass.
  #
  class PathStore
    
    # The view model class attribute
    #
    attr_reader :view_model_class
    
    # Initialize the path store
    # @param [ViewModel] view_model_class The view model class
    #
    def initialize view_model_class
      @view_model_class = view_model_class
      @name_path_mapping = {}
    end
    
    # Install in the metaclass (as an example).
    #
    def self.install_in klass
      klass.path_store = PathStore.new klass
    end
    
    # Cache the result of the rendering.
    #
    def cached options, &block
      prepare options.path_key
      result = block.call
      save options and result if result
    end
    
    # Prepare the key for the next storing procedure.
    #
    # @note If this is nil, the store will not save the path.
    #
    def prepare key
      @key = key
    end
    
    # Saves the options for the prepared key.
    #
    def save options
      self[@key] = options.file
    end
    
    # Does not save values for nil keys.
    #
    def []= key, path
      return if key.nil?
      @name_path_mapping[key] ||= path
    end
    
    # Simple [] delegation.
    #
    def [] key
      @name_path_mapping[key]
    end
    
  end
  
end