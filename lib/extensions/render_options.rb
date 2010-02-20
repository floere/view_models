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
      
      def view_model= view_model
        self[:locals] = { :view_model => view_model }.merge self[:locals] || {}
        self
      end
      
      #
      #
      def template_name= template_name
        if template_name.kind_of?(Hash)
          self.merge! template_name
          template_name = self.delete :partial
        end
        template_name.to_s.include?('/') ? specific_path(template_name) : incomplete_path(template_name)
      end
      
      private
        
        #
        #
        def specific_path name
          self.path = File.dirname name
          self.name = "#{self.prefix}#{File.basename(name)}"
        end
        
        #
        #
        def incomplete_path name
          self.path = nil
          self.name = "#{self.prefix}#{name}"
        end
        
    end
  end
end