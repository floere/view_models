# Makes certain AR Model methods available to the view model.
#
# Useful when the model is an AR Model.
#
module ViewModels
  module Extensions
    module ActiveRecord
      
      delegate :id, :to_param, :to => :model
      
      # Delegate to the action controller record identifier.
      #
      def dom_id
        ActionController::RecordIdentifier.dom_id model
      end
      
    end
  end
end