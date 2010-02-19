# Makes model reader installation, including filtering in-between possible.
#
#
module ViewModels
  module Extensions
    module ModelReader
      
      # Define a reader for a model attribute. Acts as a filtered delegation to the model. 
      #
      # You may specify a :filter_through option that is either a symbol or an array of symbols. The return value
      # from the model will be filtered through the functions (arity 1) and then passed back to the receiver. 
      #
      # Example: 
      #
      #   model_reader :foobar                                        # same as delegate :foobar, :to => :model
      #   model_reader :foobar, :filter_through => :h                 # html escape foobar 
      #   model_reader :foobar, :filter_through => [:textilize, :h]   # first textilize, then html escape
      #
      def model_reader *attributes_and_options
        options = ModelReaderOptions.new *attributes_and_options
        FilteredDelegationInstaller.new(self, options).install
      end
      
      # Bundles the model reader options and extracts the relevant structured data.
      #
      class ModelReaderOptions
        
        attr_reader :attributes, :filters
        
        def initialize *attributes_and_options
          split attributes_and_options
        end
        
        # Extract filter_through options from the options hash if there are any.
        #
        def split options
          @filters = if options.last.kind_of?(Hash)
            filter_options = options.pop
            [*(filter_options[:filter_through])].reverse
          else
            []
          end
          @attributes = options
        end
        
        def to_a
          [attributes, filters]
        end
        
      end
      
      # The filtered delegation installer installs delegators on the target
      # that are filtered.
      #
      class FilteredDelegationInstaller
        
        attr_reader :target, :attributes, :filters
        
        def initialize target, options
          @target, @attributes, @filters = target, *options
        end
        
        # Install install
        #
        def install
          attributes.each { |attribute| install_reader(attribute) }
        end
        
        # Install a reader for the given name with the given filters.
        #
        # Example:
        # # Installs a reader for model.attribute
        # #
        # * install_reader :attribute
        #
        def install_reader attribute
          target.class_eval reader_definition_for(attribute)
        end
        
        # Defines a reader for the given model attribute and filtering
        # through the given filters.
        # 
        # Note: The filters are applied from last to first element.
        #
        def reader_definition_for attribute
          "def #{attribute}; #{filtered_left_parentheses}model.#{attribute}#{right_parentheses}; end"
        end
        
        # Combines left parentheses and filters.
        #
        def filtered_left_parentheses
          filters.zip(left_parentheses).to_s
        end
        
        # Generates the needed amount of parentheses to match the left parentheses.
        #
        def right_parentheses
          ')' * filters.size
        end
        
        # Generates an array of left parentheses with
        # length <amount of filters>
        # Example:
        # # 4 Filters
        # # 
        # left_parentheses # => ['(', '(', '(', '(']
        #
        def left_parentheses
          ['('] * filters.size
        end
        
      end
      
    end
  end
end