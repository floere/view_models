module ViewModels
  module Helper
    module Rails
      
      mattr_accessor :specific_view_model_mapping
      self.specific_view_model_mapping = {}
      
      # Construct a view_model for a collection.
      #
      def collection_view_model_for pagination_array, context = self
        Collection.new pagination_array, context
      end
      
      # Get the view_model class for the given model instance.
      #
      # Note: ViewModels are usually of class ViewModels::<ModelClassName>.
      #       (As returned by default_view_model_class_for)
      #       Override specific_mapping if you'd like to install your own.
      #
      # OR:   Override default_view_model_class_for(model) if
      #       you'd like to change the default.
      #
      def view_model_class_for model
        specific_view_model_class_for(model) || default_view_model_class_for(model)
      end
      
      # Create a new view_model instance for the given model instance
      # with the given arguments.
      #
      # Note: Will emit an ArgumentError if the view model class doesn't support 2 arguments.
      #
      def view_model_for model, context = self
        view_model_class_for(model).new model, context
      end
      
      # Returns the default view_model class for the given model instance.
      #
      # Default class name is:
      # ViewModels::<ModelClassName>
      #
      # Override this method if you'd like to change the _default_
      # model-to-view_model class mapping.
      #
      # Note: Will emit a NameError if a corresponding ViewModels constant cannot be loaded.
      #
      def default_view_model_class_for model
        "ViewModels::#{model.class.name}".constantize
      end
      
      # Returns a specific view_model class for the given model instance.
      #
      # Override this method, if you want to return a specific
      # view model class for the given model.
      #
      # Note: Will emit a NameError if a corresponding ViewModels constant cannot be loaded.
      #
      def specific_view_model_class_for model
        specific_view_model_mapping[model.class]
      end
      
      # The Collection view_model helper has the purpose of presenting presentable collections.
      # * Render as list
      # * Render as table
      # * Render as collection
      # * Render a Pagination
      #
      class Collection
        
        methods_to_delegate = Enumerable.instance_methods.map(&:to_sym) +
          [:length, :size, :empty?, :each, :exit] -
          [:select] <<
          { :to => :@collection }
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
        #   * Uses 'list_item' as the default element template.
        #   * Uses a nil separator.
        #
        def list options = {}
          default_options = {
            :collection => @collection,
            :context => @context,
            :template_name => :list_item,
            :separator => nil
          }
          
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
        #   * The original context given to the collection view_model to render in.
        #   * Uses 'collection_item' as the default element template.
        #   * Uses a nil separator.
        #
        def collection options = {}
          default_options = {
            :collection => @collection,
            :context => @context,
            :template_name => :collection_item,
            :separator => nil
          }
          
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
        #   * The original context given to the collection view_model to render in.
        #   * Uses 'table_row' as the default element template.
        #   * Uses a nil separator.
        #
        def table options = {}
          options = {
            :collection => @collection,
            :context => @context,
            :template_name => :table_row,
            :separator => nil
          }.merge(options)
          
          render_partial :table, options
        end
        
        # Renders a pagination.
        #
        # Options:
        #   collection => collection to iterate over
        #   context => context to render in
        #   separator => separator between pages
        # By default, uses:
        #   * The collection of the collection view_model to iterate over.
        #   * The original context given to the collection view_model to render in.
        #   * Uses | as separator.
        #
        def pagination options = {}
          options = {
            :collection => @collection,
            :context => @context,
            :separator => '|'
          }.merge options
          
          render_partial :pagination, options
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
