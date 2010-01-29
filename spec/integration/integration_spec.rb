require File.join(File.dirname(__FILE__), '../spec_helper')

require 'view_models/base'
class ViewModels::Subclass < ViewModels::Base; end
class ViewModels::SubSubclass < ViewModels::Subclass; end

describe 'Integration' do
  
  before(:each) do
    @controller_class = stub :klass, :view_paths => 'spec/integration', :controller_path => 'app/controllers/test'
    @context          = stub :controller, :class => @controller_class
    @view_paths       = stub :find_template
    @view             = stub :view, :controller => @context, :view_paths => @view_paths
    @view_model       = ViewModels::SubSubclass.new @context, @view
  end
  
  describe 'render_as' do
    describe 'template finding' do
      it "should use its template" do
        @view_model.render_as(:exists).should == 'html exists' # The default
      end
      it "should use the subclass' template" do
        @view_model.render_as(:no_sub_subclass).should == 'no_sub_subclass'
      end
      it "should fail" do
        @view_model.render_as(:none).should == nil
      end
    end
    describe 'format' do
      it 'should render text' do
        @view_model.render_as(:exists, :format => '').should == 'exists'
      end
      it 'should render text' do
        @view_model.render_as(:exists, :format => :text).should == 'text exists'
      end
      it 'should render html' do
        @view_model.render_as(:exists, :format => :html).should == 'html exists'
      end
    end
    describe 'locals' do
      it 'should render text' do
        @view_model.render_as(:exists, :format => '', :locals => { :local_name => :some_local }).should == 'existssome_local'
      end
      it 'should render text' do
        @view_model.render_as(:exists, :format => :text, :locals => { :local_name => :some_local }).should == 'text existssome_local'
      end
      it 'should render html' do
        @view_model.render_as(:exists, :format => :html, :locals => { :local_name => :some_local }).should == 'html existssome_local'
      end
    end
  end
  
end