module ViewModels
  module Helpers
    module Mapping
      
      # The Collection view_model helper has the purpose of presenting presentable collections.
      # * Render as list
      # * Render as table
      # * Render as collection
      # * Render a pagination
      #
      class Collection
        private
          
          # Helper method that renders a partial in the context of the context instance.
          #
          # Example:
          #   If the collection view_model helper has been instantiated in the context
          #   of a controller, render will be called in the controller.
          #
          def render_partial name, locals
            @context.instance_eval { render "view_models/collection/_#{name}", :locals => locals }
          end
      end
      
    end
  end
end