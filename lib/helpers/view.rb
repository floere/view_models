module ViewModels
  module Helpers
    # Module for conveniently including common view_helpers into a view_model
    #
    module View
      
      # Include hook.
      #
      def self.included view_model
        self.all_view_helpers.each { |helper| include_into view_model, helper }
      end
      
      def self.include_into view_model, helper
        view_model.class_eval { include helper }
      end
      
      def self.all_view_helpers
        [
          ActionView::Helpers::ActiveRecordHelper,
          ActionView::Helpers::TagHelper,
          ActionView::Helpers::FormTagHelper,
          ActionView::Helpers::FormOptionsHelper,
          ActionView::Helpers::FormHelper,
          ActionView::Helpers::UrlHelper,
          ActionView::Helpers::AssetTagHelper,
          ActionView::Helpers::PrototypeHelper,
          ActionView::Helpers::TextHelper,
          ActionView::Helpers::SanitizeHelper,
          ERB::Util
        ]
      end
  
    end
  end
end