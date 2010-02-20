# Base Module for ViewModels.
#
module ViewModels
  
  # A simple path store. Designed to remove a bit of complexity from the base view model.
  #
  class PathStore
    
    attr_reader :view_model_class
    
    def initialize view_model_class
      @view_model_class = view_model_class
      @name_path_mapping = {}
    end
    
    #
    #
    def self.install_in klass
      klass.path_store = PathStore.new klass
    end
    
    # Prepare the key for the next storing procedure.
    #
    def prepare key
      @key = key
    end
    
    #
    #
    def save options
      self[@key] = options[:file]
    end
    
    #
    #
    def []= key, path
      @name_path_mapping[key] ||= path
    end
    
    #
    #
    def [] key
      @name_path_mapping[key]
    end
    
  end
  
end