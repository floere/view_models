#
#
module ViewModels
  module Extensions
    
    module RenderOptions
      
      attr_accessor :path, :name, :prefix
      
      # def format
      #   self[:format]
      # end
      # 
      # def format= format
      #   self[:format] ||= format
      # end
      
      #
      #
      def partial= name
        self.prefix = :'_'
        self.template_name = name
      end
      #
      #
      def template= name
        self.prefix = nil
        self.template_name = name
      end
      
      #
      #
      def view_model= view_model
        self[:locals] = { :view_model => view_model }.merge self[:locals] || {}
      end
      
      private
        
        #
        #
        def template_name= template_name
          template_name = deoptionize template_name
          template_name.to_s.include?('/') ? specific_path(template_name) : incomplete_path(template_name)
        end
        
        #
        #
        def deoptionize template_name
          if template_name.kind_of?(Hash)
            self.merge! template_name
            self.delete :partial
          else
            template_name
          end
        end
        
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