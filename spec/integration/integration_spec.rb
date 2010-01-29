require File.join(File.dirname(__FILE__), '../spec_helper')

require 'view_models/base'
class ViewModels::Subclass < ViewModels::Base; end
class ViewModels::SubSubclass < ViewModels::Subclass; end

describe 'Integration' do
  
  # before(:all) do
  #   Dir.chdir 'spec/integration'
  # end
  
  before(:each) do
    @controller_class = stub :klass, :view_paths => 'spec/integration', :controller_path => 'app/controllers/test'
    @context          = stub :controller, :class => @controller_class
    @view_paths       = stub :find_template
    @view             = stub :view, :controller => @context, :view_paths => @view_paths
    @view_model       = ViewModels::SubSubclass.new @context, @view
  end
  
  describe 'template finding' do
    it "should use its template" do
      in_the @view_model do
        render_as(:exists).should == 'exists'
      end
    end
    it "should use the subclass' template" do
      in_the @view_model do
        render_as(:no_sub_subclass).should == 'no_sub_subclass'
      end
    end
    it "should fail" do
      in_the @view_model do
        render_as(:none).should == nil
      end
    end
  end
  
end