module Representers
  module Helpers
    # Module for conveniently including common view_helpers into a representer
    #
    module View
  
      def self.included(representer)
        self.all_view_helpers.each do |helper|
          representer.class_eval { include helper }
        end
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