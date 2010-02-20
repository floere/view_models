# Base Module for ViewModels.
#
module ViewModels
  
  # TODO
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
      p klass.name
      klass.path_store = PathStore.new klass
    end
    
    # Prepare the key for the next storing procedure.
    #
    def prepare key
      @key = key
    end
    
    #
    #
    def store path
      self[@key] = path
    end
    
    #
    #
    def [] view, name, options
      @name_path_mapping[view.path_key(name)] || view_model_class.template_path(name, options) # TODO rewrite
    end
    
    #
    #
    def []= key, path # key, options
      @name_path_mapping[key] ||= path # TODO rewrite
    end
    
  end
  
end