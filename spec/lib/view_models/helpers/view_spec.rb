require 'spec_helper'

describe ViewModels::Helpers::View do
  
  class TestClass < ActionView::Base; end
  
  describe "including it" do
    it "should include all the view helpers" do
      in_the TestClass do
        include ViewModels::Helpers::View
      end
      
      TestClass.should include(ActionView::Helpers)
      TestClass.should include(ERB::Util)
    end
  end

end
