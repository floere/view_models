require File.join(File.dirname(__FILE__), '../spec_helper')

require File.join(File.dirname(__FILE__), 'models/subclass')
require File.join(File.dirname(__FILE__), 'models/sub_subclass')

require 'helpers/rails'
ActionView::Base.send :include, ViewModels::Helper::Rails

require 'view_models/base'
require File.join(File.dirname(__FILE__), 'view_models/subclass')
require File.join(File.dirname(__FILE__), 'view_models/sub_subclass')


describe 'Integration' do
  
  before(:each) do
    @model            = SubSubclass.new
    @controller_class = stub :klass, :view_paths => 'spec/integration/views', :controller_path => 'app/controllers/test'
    @context          = stub :controller, :class => @controller_class
    @view_paths       = stub :find_template
    @view             = stub :view, :controller => @context, :view_paths => @view_paths
    @view_model       = ViewModels::SubSubclass.new @model, @view
  end
  
  # describe 'collection rendering' do
  #   it 'should description' do
  #     @view_model.render_as(:list_example).should == 'html exists' # The default
  #   end
  # end
  
  describe 'model attributes' do
    it 'should pass through unfiltered attributes' do
      @view_model.some_untouched_attribute.should == :some_value
    end
    it 'should filter some attributes' do
      @view_model.some_filtered_attribute.should == '%3Cscript%3Efilter+me%3C%2Fscript%3E'
    end
  end
  
  describe 'render_as' do
    describe 'template inheritance' do
      it "should use its template" do
        @view_model.render_as(:exists).should == 'html exists' # The default
      end
      it "should use the subclass' template" do
        @view_model.render_as(:no_sub_subclass).should == 'no sub subclass'
      end
      it "should fail" do
        @view_model.render_as(:none).should == nil
      end
    end
    describe 'format' do
      it 'should render html' do
        @view_model.render_as(:exists, :format => nil).should == 'html exists' # the default
      end
      it 'should render erb' do
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
      it 'should render html' do
        @view_model.render_as(:exists, :locals => { :local_name => :some_local }).should == 'html exists with some_local'
      end
      it 'should render html' do
        @view_model.render_as(:exists, :format => nil, :locals => { :local_name => :some_local }).should == 'html exists with some_local'
      end
      it 'should render text' do
        @view_model.render_as(:exists, :format => '', :locals => { :local_name => :some_local }).should == 'exists with some_local'
      end
      it 'should render text' do
        @view_model.render_as(:exists, :format => :text, :locals => { :local_name => :some_local }).should == 'text exists with some_local'
      end
      it 'should render html' do
        @view_model.render_as(:exists, :format => :html, :locals => { :local_name => :some_local }).should == 'html exists with some_local'
      end
    end
  end
  
end