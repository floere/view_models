require File.join(File.dirname(__FILE__), '../spec_helper')

require 'helpers/view'

describe ViewModels::Helpers::View do
  
  class TestClass; end
  
  describe 'description' do
    it 'should description' do
      
    end
  end
  
  describe "including it" do
    it "should include all the view helpers" do
      in_the TestClass do
        include ViewModels::Helpers::View
      end
      
      TestClass.should include(ActionView::Helpers::ActiveRecordHelper)
      TestClass.should include(ActionView::Helpers::TagHelper)
      TestClass.should include(ActionView::Helpers::FormTagHelper)
      TestClass.should include(ActionView::Helpers::FormOptionsHelper)
      TestClass.should include(ActionView::Helpers::FormHelper)
      TestClass.should include(ActionView::Helpers::UrlHelper)
      TestClass.should include(ActionView::Helpers::AssetTagHelper)
      TestClass.should include(ActionView::Helpers::PrototypeHelper)
      TestClass.should include(ActionView::Helpers::TextHelper)
      TestClass.should include(ActionView::Helpers::SanitizeHelper)
      TestClass.should include(ERB::Util)
    end
  end

end
