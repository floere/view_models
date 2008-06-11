require File.join(File.dirname(__FILE__), '../../../spec_helper')

require 'rspec_on_rails'

describe '_list.html.haml' do
  include ViewSpecHelper
  
  describe "description" do
    before(:each) do
      @collection_mock = flexmock(:collection)
    end
    it "should description" do
      render_template
    end
  end
  
  private
  
    def render_template
      render :partial => 'list.html.haml', :locals => { :collection => @collection_mock }
    end
  
end