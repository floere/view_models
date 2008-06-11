module PresenterHelper
  
  # Error thrown if a presenter for the given model class is not available.
  #
  class MissingPresenterError < RuntimeError; end
  
  # Error thrown if the presenter loaded is not a presenter.
  #
  class NotAPresenterError < RuntimeError; end
  
  # Should return a hash in the form of:
  # { SomeModules::ModelClass => SomeModules::PresenterClass }
  #
  # Normally, the default convention is fine, but sometimes you might want to have
  # a specific presenter mapping: This is the place to override it.
  #
  # Note: specific_PRESENTER_mapping to not have the method collide with
  #       existing specific_mapping methods.
  #
  def specific_presenter_mapping
    # your hash of specific model-to-presenter class mappings
    {}
  end
  
  # Construct a presenter for a collection.
  #
  def collection_presenter_for(pagination_array, context=self)
    Collection.new(pagination_array, context)
  end
  
  # Create a new presenter instance for the given model instance
  # with the given arguments.
  #
  # Note: Presenters are usually of class Presenters::<ModelClassName>.
  #       (As returned by default_presenter_class_for)
  #       Override specific_mapping if you'd like to install your own.
  #
  # OR:   Override default_presenter_class_for(model) if
  #       you'd like to change the default.
  #
  def presenter_for(model, context = self)
    # Is there a specific mapping?
    presenter_class = specific_presenter_mapping[model.class]
    
    # If not, get the default mapping.
    presenter_class = default_presenter_class_for(model) unless presenter_class
    
    unless presenter_class < Presenters::Base
      raise NotAPresenterError.new("#{presenter_class} is not a presenter.")
    end
    
    # And create a presenter for the model.
    presenter_class.new(model, context)
  rescue NameError => e
    raise MissingPresenterError.new("No presenter for #{model.class}.")
  end
  
  # Returns the default presenter class for the given model instance.
  #
  # Default class name is:
  # Presenters::<ModelClassName>
  #
  # Override this method if you'd like to change the _default_
  # model-to-presenter class mapping.
  #
  def default_presenter_class_for(model)
    "Presenters::#{model.class.name}".constantize
  end
  
  # The Collection presenter helper has the purpose of presenting presentable collections.
  # * Render as list
  # * Render as table
  # * Render as collection
  # * Render a Pagination
  #
  class Collection

    def initialize(collection, context)
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
    #   * The collection of the collection presenter to iterate over.
    #   * The original context given to the collection presenter to render in.
    #   * Uses 'list_item' as the default element template.
    #   * Uses a nil separator.
    #
    def list(options = {})
      default_options = {
        :collection => @collection,
        :context => @context,
        :template_name => :list_item,
        :separator => nil
      }

      render_partial 'list', default_options.merge(options)
    end

    # Renders a collection.
    #
    # Note: The only difference between a list and a collection is the enclosing
    # list type. While list uses ol, the collection uses ul.
    #
    # Options:
    #   collection => collection to iterate over
    #   context => context to render in
    #   template_name => template to render for each model element
    #   separator => separator between each element
    # By default, uses:
    #   * The collection of the collection presenter to iterate over.
    #   * The original context given to the collection presenter to render in.
    #   * Uses 'collection_item' as the default element template.
    #   * Uses a nil separator.
    #
    def collection(options = {})
      default_options = {
        :collection => @collection,
        :context => @context,
        :template_name => :collection_item,
        :separator => nil
      }

      render_partial 'collection', default_options.merge(options)
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
    #   * The collection of the collection presenter to iterate over.
    #   * The original context given to the collection presenter to render in.
    #   * Uses 'table_row' as the default element template.
    #   * Uses a nil separator.
    #
    def table(options = {})
      options = {
        :collection => @collection,
        :context => @context,
        :template_name => :table_row,
        :separator => nil
      }.merge(options)

      render_partial 'table', options
    end

    # Renders a pagination.
    #
    # Options:
    #   collection => collection to iterate over
    #   context => context to render in
    #   separator => separator between pages
    # By default, uses:
    #   * The collection of the collection presenter to iterate over.
    #   * The original context given to the collection presenter to render in.
    #   * Uses | as separator.
    #
    def pagination(options = {})
      options = {
        :collection => @collection,
        :context => @context,
        :separator => '|'
      }.merge(options)

      render_partial 'pagination', options
    end

    private
      
      # Helper method that renders a partial in the context of the context instance.
      #
      # Example:
      # If the collection presenter helper has been instantiated in the context
      # of a controller, render will be called in the controller.
      #
      def render_partial(name, locals)
        @context.instance_eval { render :partial => "presenters/collection/#{name}", :locals => locals }
      end

  end
end
