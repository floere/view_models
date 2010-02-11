# Makes model reader installation, including filtering in-between possible.
#
#
module ViewModels
  module Extensions
    module ModelReader
      
      def self.install target, options
        fields, filters = split options
        
        fields.each { |field| install_reader(target, field, filters) }
      end
      
      # # Extract options hash from args array if there are any.
      # # Returns nil if there are none.
      # #
      # # Note: Destructive.
      # #
      # def self.extract_options_from ary
      #   ary.pop if ary.last.kind_of?(Hash)
      # end
      
      # Extract filter_through options from the options hash if there are any.
      #
      def self.split options
        filters = if options.last.kind_of?(Hash)
          filter_options = options.pop
          [*(filter_options[:filter_through])].reverse
        else
          []
        end
        p [options, filters]
        [options, filters]
      end
      
      # Install a reader for the given name with the given filters.
      #
      # Example:
      # # Installs a reader for model.attribute which is first upcased, then h'd.
      # #
      # * install_reader :attribute, [:h, :upcase]
      #
      def self.install_reader target, name, filters
        target.class_eval reader_definition_for(name, filters)
      end
      
      # Defines a reader for the given model field and filtering
      # through the given filters, from right to left.
      # 
      # Note: The filters are applied from last to first element.
      #
      def self.reader_definition_for field, filters = []
        size              = filters.size
        left_parentheses  = filters.zip(['('] * size)
        right_parentheses = ')' * size
        "def #{field}; #{left_parentheses}model.#{field}#{right_parentheses}; end"
      end
      
    end
  end
end