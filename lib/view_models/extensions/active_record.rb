# Makes certain AR Model methods available to the view model.
#
# Useful when the model is an AR Model.
#
# TODO Split into id delegations and AR/AC specific stuff.
#
module ViewModels
  module Extensions
    module ActiveRecord
      
      # id and param are simply delegated to the model.
      #
      # This makes it possible to use the view_model
      # for e.g. url generation:
      # * edit_user_path(view_model)
      #
      delegate :id, :to_param, :to => :model
      
      # Delegate to the action controller record identifier.
      #
      def dom_id
        puts 'HELLO'
        ActionController::RecordIdentifier.dom_id model
      end
      
    end
  end
end