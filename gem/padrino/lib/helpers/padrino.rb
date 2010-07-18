module ViewModels
  module Helpers
    
    class << self
      def registered app
        app.send :include, ViewModels::Helpers::Mapping
        
        Padrino.set_load_paths File.join(app.root, "/view_models")
        
        Padrino.require_dependencies File.join(app.root, "/view_models.rb")
        # FIXME Needs to require in a specific order.
        #
        Padrino.require_dependencies File.join(app.root, "/view_models/**/*.rb")
      end
      alias :included :registered
    end
    
  end
end