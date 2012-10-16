# Makes model reader installation, including filtering in-between possible.
#
#
module ViewModels
  
  # Extensions of the View Model Class
  #
  module Extensions
    
    # Model Reader extension. Allows to define model readers on view models, accessing attributes and methods
    # on models
    #
    module ModelReader
      
      # Define a reader for a model attribute. Acts as a filtered delegation to the model. 
      #
      # You may specify a :filter_through option that is either a symbol or an array of symbols. The return value
      # from the model will be filtered through the functions (arity 1) and then passed back to the receiver.
      # @param [Symbol, Hash] attributes_and_options The attributes and options for the model reader
      #
      # @example install different model readers
      #
      #   model_reader :foobar                                        # same as delegate :foobar, :to => :model
      #   model_reader :foobar, :filter_through => :h                 # html escape foobar 
      #   model_reader :foobar, :filter_through => [:textilize, :h]   # first textilize, then html escape
      #
      def model_reader *attributes_and_options
        options = Options.new *attributes_and_options
        FilteredDelegationInstaller.new(self, options).install
      end
      
      # Bundles the model reader options and extracts the relevant structured data.
      #
      class Options
        
        attr_reader :attributes, :filters
        
        def initialize *attributes_and_options
          split attributes_and_options
        end
        
        # Extract filter_through options from the options hash if there are any.
        # @param [Hash] options the options to split
        #
        def split options
          @filters = if options.last.kind_of?(Hash)
            [*(options.pop[:filter_through])].reverse
          else
            []
          end
          @attributes = options
        end
        
        # Render the options to an array
        # @return [Array] The attributes and the filters in this order
        #
        def to_a
          [attributes, filters]
        end
        
      end
      
      # The filtered delegation installer installs delegators on the target
      # that are filtered.
      #
      class FilteredDelegationInstaller
        
        # The attributes target, attributes, filters
        #
        attr_reader :target, :attributes, :filters
        
        # Initialize a new filtered delegation
        # @param [ViewModel] target the target to install the filtered delegation in
        # @param [ModelReader::Options] options The options for the filtered delegation
        #
        def initialize target, options
          @target, @attributes, @filters = target, *options
        end
        
        # Install a reader for each attribute
        #
        def install
          attributes.each { |attribute| install_reader(attribute) }
        end
        
        # Install a reader for the given name with the given filters.
        #
        # @example Installs a reader for model.attribute
        #   install_reader :attribute
        #
        def install_reader attribute
          target.class_eval reader_definition_for(attribute)
        end
        
        # Defines a reader for the given model attribute and filtering
        # through the given filters.
        # 
        # @note The filters are applied from last to first element.
        #
        def reader_definition_for attribute
          "def #{attribute}; #{filtered_left_parentheses}model.#{attribute}#{right_parentheses}; end"
        end
        
        # Combines left parentheses and filters.
        #
        def filtered_left_parentheses
          filters.zip(left_parentheses).join
        end
        
        # Generates the needed amount of parentheses to match the left parentheses.
        #
        def right_parentheses
          ')' * filters.size
        end
        
        # Generates an array of left parentheses with
        # length <amount of filters>
        # @example for 4 Filters
        #   left_parentheses # => ['(', '(', '(', '(']
        #
        def left_parentheses
          ['('] * filters.size
        end
        
      end
      
    end
  end
end