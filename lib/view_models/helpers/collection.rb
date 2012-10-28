module ViewModels
  
  # Helpers you can include in just about anything to get convenient access to view model functionality
  #
  module Helpers
    
    # Mapping helpers install collection_view_model_for and view_model_for, which you can use with instances
    # to conveniently instantiate a view model for it
    #
    module Mapping
      
      # Construct a view_model for a collection.
      #
      # @todo Think about moving it into view_model_for, or renaming it view_models_for.
      #
      def collection_view_model_for array_or_pagination, context = self
        Collection.new array_or_pagination, context
      end
      
      # The Collection view_model helper has the purpose of presenting presentable collections.
      # * Render as list
      # * Render as table
      # * Render as collection
      # * Render a pagination
      #
      class Collection
        
        # Delegate collection relevant methods to the collection.
        # @todo Why is as_json not yet loaded in Enumerable.instance_methods 
        # when this file is loaded in the spec, require active_support is installed before view_models are loaded
        # Load Order ? Rails Blagic?
        #
        self.delegate *[Enumerable.instance_methods, :length, :size, :empty?, :each, :exit, :as_json, { :to => :@collection }].flatten
        
        #
        #
        def initialize collection, context
          @collection, @context = collection, context
        end
        
        # Renders a list (in the broadest sense of the word).
        #
        # @param [Hash] options The options for the list
        # @option options :collection the collection to iterate over (default: The collection of the collection view_model to iterate over)
        # @option options :context context to render in (default: The original context given to the collection view_model to render in)
        # @option options :template_name the template to render for each model element (default: list_item as the default element template)
        # @option options :separator the separator between each element (default: nil separator in html)
        #
        def list options = {}          
          render_partial :list, template_locals(:list_item, options)
        end
        
        # Renders a collection.
        #
        # @note The only difference between a list and a collection is the enclosing list type. While list uses ol, the collection uses ul.
        #
        # @param [Hash] options The options for the collection
        # @option options :collection the collection to iterate over (default: The collection of the collection view_model to iterate over)
        # @option options :context the context to render in (default: The original context given to the collection view_model to render in)
        # @option options :template_name the template to render for each model element (default: Uses :collection_item as the default element template)
        # @option options :separator => separator between each element (default: nil separator in html)
        #
        def collection options = {}          
          render_partial :collection, template_locals(:collection_item, options)
        end
        
        # Renders a table.
        #
        # Note: Each item represents a table row.
        #
        # @param [Hash] options The options for the table
        # @option options :collection the collection to iterate over (default: The collection of the collection view_model to iterate over)
        # @option options :context the context to render in (default: The original context given to the collection view_model to render in)
        # @option options :template_name the template to render for each model element (default: Uses :table_row as the default element template)
        # @option options :separator => separator between each element (default: nil separator in html)
        #
        def table options = {}          
          render_partial :table, template_locals(:table_row, options)
        end
        
        # Renders a pagination.
        #
        # @param [Hash] options The options for the collection
        # @option options :collection the collection to iterate over (default: The collection of the collection view_model to iterate over)
        # @option options :context the context to render in (default: The original context given to the collection view_model to render in)
        # @option options :template_name the template to render for each model element (default: Uses :collection_item as the default element template)
        # @option options :separator => separator between each element (default: | separator in html)
        #
        def pagination options = {}          
          render_partial :pagination, template_locals(:pagination, {:separator => '|'}.merge(options))
        end
        
        private
          
          # Helper method that renders a partial in the context of the context instance.
          #
          # @note If the collection view_model helper has been instantiated in the context of a controller, render will be called in the controller.
          #
          def render_partial name, locals
            @context.instance_eval { render :partial => "view_models/collection/#{name}", :locals => locals }
          end
          
          # Helper method that constructs locals for render_partial
          #
          def template_locals template_name, supersed_options 
            { :collection => @collection, :template_name => template_name, :separator => nil }.merge supersed_options
          end
          
      end
      
    end
  end
end