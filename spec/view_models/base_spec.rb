require File.join(File.dirname(__FILE__), '../spec_helper')

require 'view_models/base'

describe ViewModels::Base do
  
  describe "readers" do
    describe "model" do
      before(:each) do
        @model      = stub :model
        @view_model = ViewModels::Base.new @model, nil
      end
      it "should have a reader" do
        @view_model.model.should == @model
      end
    end
    describe "controller" do
      before(:each) do
        @context    = stub :controller
        @view_model = ViewModels::Base.new nil, @context
      end
      it "should have a reader" do
        @view_model.controller.should == @context
      end
    end
  end
  
  describe "context recognition" do
    describe "context is a view" do
      before(:each) do
        @view = stub :view, :controller => 'controller'
        @view_model = ViewModels::Base.new nil, @view
      end
      it "should get the controller from the view" do
        @view_model.controller.should == 'controller'
      end
    end
    describe "context is a controller" do
      before(:each) do
        @controller = stub :controller
        @view_model = ViewModels::Base.new nil, @controller
      end
      it "should just use it for the controller" do
        @view_model.controller.should == @controller
      end
    end
  end
  
  class ModelReaderModel < Struct.new(:some_model_value); end
  describe ".model_reader" do
    before(:each) do
      @model = ModelReaderModel.new
      @view_model = ViewModels::Base.new(@model, nil)
      class << @view_model
        def a(s); s << 'a' end
        def b(s); s << 'b' end
      end
      @model.some_model_value = 's'
    end
    it "should call filters in a given pattern" do
      @view_model.class.model_reader :some_model_value, :filter_through => [:a, :b, :a, :a]
      
      @view_model.some_model_value.should == 'sabaa'
    end
    it "should pass through the model value if no filters are installed" do
      @view_model.class.model_reader :some_model_value
      
      @view_model.some_model_value.should == 's'
    end
    it "should call filters in a given pattern" do
      @view_model.class.model_reader [:some_model_value], :filter_through => [:a, :b, :a, :a]
      
      @view_model.some_model_value.should == 'sabaa'
    end
    it "should handle a single filter" do
      @view_model.class.model_reader :some_model_value, :filter_through => :a
      
      lambda { @view_model.some_model_value }.should_not raise_error
    end
    it "should handle an array of readers" do
      @view_model.class.model_reader [:some_model_value, :some_other_model_value], :filter_through => :a
      
      lambda { @view_model.some_model_value }.should_not raise_error
    end
    describe 'extract_options_from' do
      context 'with hash as last element' do
        it 'should return it' do
          in_the @view_model.class do
            extract_options_from([:test, { :some => :hash }]).should == { :some => :hash }
          end
        end
      end
      context 'without hash as last element' do
        it 'should return nil' do
          in_the @view_model.class do
            extract_options_from([:test]).should == nil
          end
        end
      end
    end
    describe 'extract_filters_from' do
      context 'with nil options' do
        it 'should return an empty array' do
          in_the @view_model.class do
            extract_filters_from(nil).should == []
          end
        end
      end
      context 'with existing options' do
        it 'should return a reverse array' do
          in_the @view_model.class do
            extract_filters_from( :filter_through => [:a, :b, :c] ).should == [:c, :b, :a]
          end
        end
      end
    end
    describe 'reader_definition_for' do
      context 'with filter names' do
        it 'should return a correct definition' do
          in_the @view_model.class do
            reader_definition_for(:some_field, [:a, :b, :c, :d]).should == "def some_field; a(b(c(d(model.some_field)))); end"
          end
        end
      end
      context 'without filter names' do
        it 'should return a correct definition' do
          in_the @view_model.class do
            reader_definition_for(:some_field).should == "def some_field; model.some_field; end"
          end
        end
      end
    end
  end
  
  describe ".master_helper_module" do
    before(:each) do
      class ViewModels::SpecificMasterHelperModule < ViewModels::Base; end
    end
    it "should be a class specific inheritable accessor" do
      ViewModels::SpecificMasterHelperModule.master_helper_module = :some_value
      ViewModels::SpecificMasterHelperModule.master_helper_module.should == :some_value
    end
    it "should be an instance of Module on Base" do
      ViewModels::Base.master_helper_module.should be_instance_of(Module)
    end
  end
  
  describe ".controller_method" do
    it "should set up delegate calls to the controller" do
      ViewModels::Base.should_receive(:delegate).once.with(:method1, :method2, :to => :controller)
      
      ViewModels::Base.controller_method :method1, :method2
    end
  end
  
  describe ".helper" do
    it "should include the helper" do
      helper_module = Module.new
      
      ViewModels::Base.should_receive(:include).once.with helper_module
      
      ViewModels::Base.helper helper_module
    end
    it "should include the helper in the master helper module" do
      master_helper_module = Module.new
      ViewModels::Base.should_receive(:master_helper_module).and_return master_helper_module
      
      helper_module = Module.new
      master_helper_module.should_receive(:include).once.with helper_module
      
      ViewModels::Base.helper helper_module
    end
  end
    
  describe ".view_model_path" do
    it "should call underscore on its name" do
      name = stub :name
      ViewModels::Base.should_receive(:name).once.and_return name
      name.should_receive(:underscore).once.and_return :underscored_name
      
      in_the ViewModels::Base do
        view_model_path.should == :underscored_name
      end
    end
  end
  
  describe "#logger" do
    it "should delegate to the controller" do
      controller = stub :controller
      view_model = ViewModels::Base.new nil, controller
      
      controller.should_receive(:logger).once
      
      in_the view_model do
        logger
      end
    end
  end
    
  context "with mocked Presenter" do
    before(:each) do
      @model = stub :model
      @context = stub :context
      @view_model = ViewModels::Base.new @model, @context
      
      @view_name = stub :view_name
      @view_instance = stub :view_instance
    end
    describe '#render' do
      it 'should delegate to the class' do
        view, name = stub(:view), stub(:name)
        
        @view_model.class.should_receive(:render).once.with view, name, anything
        
        in_the @view_model do
          render view, name, {}
        end
      end
      it 'should inject itself into the options' do
        @view_model.class.should_receive(:render).once.with anything, anything, { :locals => { :view_model => @view_model } }
        
        in_the @view_model do
          render nil, nil, {}
        end
      end
    end
    describe "#render_as" do
      before(:each) do
        @view_model.stub! :view_instance_for => @view_instance
        @path = stub :path
        @view_model.stub! :template_path => @path
        @view_instance.stub! :render
      end
      it "should call render with the correct default partial and the view_model as locals" do
        @view_model.should_receive(:render).with @view_instance, @view_name, {}
        
        @view_model.render_as @view_name
      end
      it "should call render with the correct default partial and the view_model as locals with locals" do
        @view_model.should_receive(:render).with @view_instance, 'some/specific/path', :locals => { :some_local => :some_value }
        
        @view_model.render_as 'some/specific/path', :locals => { :some_local => :some_value }
      end
      it "should not call template_format=" do
        @view_instance.should_receive(:template_format=).never
        
        @view_model.render_as @view_name
      end
      it "should pass on the specified locals" do
        @view_model.should_receive(:render).with @view_instance, @view_name, :locals => { :some_local => :some_value }
        
        @view_model.render_as @view_name, :locals => { :some_local => :some_value }
      end
      it "should override the default view_model if specified" do
        specific_view_model = stub :specific_view_model
        
        @view_model.should_receive(:render).with @view_instance, @view_name, :locals => { :view_model => specific_view_model }
        
        @view_model.render_as @view_name, :locals => { :view_model => specific_view_model }
      end
      it "should override the default template if specified" do
        template = stub :template
        
        @view_model.should_receive(:render).with @view_instance, @view_name, :partial => template
        
        @view_model.render_as @view_name, :partial => template
      end
    end
    
    describe "#view_model_template_path" do
      describe "absolute path given" do
        it "should use it as given" do
          in_the @view_model.class do
            template_path('some/path/to/template').should == 'some/path/to/template'
          end
        end
        it 'should memoize the result' do
          in_the @view_model.class do
            @view_model.class.should_receive(:name).never
            
            template_path 'some/path/to/template'
            
            template_path('some/path/to/template').should == 'some/path/to/template'
          end
        end
      end
      describe "with just the template name" do
        it "should prepend the view_model path" do
          ViewModels::Base.stub! :view_model_path => 'some/view_model/path/to'
          
          in_the @view_model.class do
            template_path('template').should == 'some/view_model/path/to/template'
          end
        end
      end
    end
    
    describe "#view_instance" do
      it 'should call new on ViewModels::View' do
        ViewModels::View.should_receive(:new).once.with @context, anything
        
        in_the @view_model do
          view_instance
        end
      end
    end
    
  end
  
end