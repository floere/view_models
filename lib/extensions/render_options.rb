# Makes certain AR Model methods available to the view model.
#
# Useful when the model is an AR Model.
#
module ViewModels
  module Extensions
    module RenderOptions
      
      attr_accessor :path, :name, :prefix
      
      #
      #
      def partial!
        self.prefix = :'_'
        self
      end
      #
      #
      def template!
        self.prefix = nil
        self
      end
      
      def add_view_model view_model
        self[:locals] = { :view_model => view_model }.merge self[:locals] || {}
        self
      end
      
      #
      #
      def internalize name
        prefix = self.prefix
        # Specific path like 'view_models/somethingorother/foo.haml' given.
        #
        if name.to_s.include?('/')
          self.path = File.dirname name
          self.name = "#{prefix}#{File.basename(name)}"
        else
          self.name = "#{prefix}#{name}"
        end
        self
      end
      
    end
  end
end