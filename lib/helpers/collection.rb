module ViewModels
  module Helpers
    module Rails
      
      # Construct a view_model for a collection.
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
        
        #
        #
        methods_to_delegate = [
          Enumerable.instance_methods.map(&:to_sym),
          :length, :size, :empty?, :each, :exit,
          { :to => :@collection }
        ].flatten
        self.delegate *methods_to_delegate
        def select *args, &block # active_support fail?
          @collection.select *args, &block
        end
        
        def initialize collection, context
          @collection, @context = collection, context
        end
        
        # Renders a list (in the broadest sense of the word).
        #
        # Options:
        #   collection => collection to iterate over
        #   context => context to render in
        #   template_name => template to render for each model element
        #   separator => separator between each element
        # By default, uses:
        #   * The collection of the collection view_model to iterate over.
        #   * The original context given to the collection view_model to render in.
        #   * Uses :list_item as the default element template.
        #   * Uses a nil separator in html.
        #
        def list options = {}
          default_options = { :collection => @collection, :template_name => :list_item, :separator => nil }
          
          render_partial :list, default_options.merge(options)
        end
        
        # Renders a collection.
        #
        # Note: The only difference between a list and a collection is the enclosing
        #       list type. While list uses ol, the collection uses ul.
        #
        # Options:
        #   collection => collection to iterate over
        #   context => context to render in
        #   template_name => template to render for each model element
        #   separator => separator between each element
        # By default, uses:
        #   * The collection of the collection view_model to iterate over.
        #   * Uses :collection_item as the default element template.
        #   * Uses a nil separator.
        #
        def collection options = {}
          default_options = { :collection => @collection, :template_name => :collection_item, :separator => nil }
          
          render_partial :collection, default_options.merge(options)
        end
        
        # Renders a table.
        #
        # Note: Each item represents a table row.
        #
        # Options:
        #   collection => collection to iterate over
        #   context => context to render in
        #   template_name => template to render for each model element
        #   separator => separator between each element
        # By default, uses:
        #   * The collection of the collection view_model to iterate over.
        #   * Uses :table_row as the default element template.
        #   * Uses a nil separator.
        #
        def table options = {}
          default_options = { :collection => @collection, :template_name => :table_row, :separator => nil }
          
          render_partial :table, default_options.merge(options)
        end
        
        # Renders a pagination.
        #
        # Options:
        #   collection => collection to iterate over
        #   context => context to render in
        #   separator => separator between pages
        # By default, uses:
        #   * The collection of the collection view_model to iterate over.
        #   * Uses | as separator.
        #
        def pagination options = {}
          default_options = { :collection => @collection, :separator => '|' }
          
          render_partial :pagination, default_options.merge(options)
        end
        
        private
          
          # Helper method that renders a partial in the context of the context instance.
          #
          # Example:
          #   If the collection view_model helper has been instantiated in the context
          #   of a controller, render will be called in the controller.
          #
          def render_partial name, locals
            @context.instance_eval { render :partial => "view_models/collection/#{name}", :locals => locals }
          end
      end
      
    end
  end
end