require File.join(File.dirname(__FILE__), '../spec_helper')

require 'representers/base'

describe Representers::Base do
  
  describe "readers" do
    describe "model" do
      before(:each) do
        @model_mock = flexmock(:model)
        @representer = Representers::Base.new(@model_mock, nil)
      end
      it "should have a reader" do
        @representer.model.should == @model_mock
      end
    end
    describe "controller" do
      before(:each) do
        @context_mock = flexmock(:controller)
        @representer = Representers::Base.new(nil, @context_mock)
      end
      it "should have a reader" do
        @representer.controller.should == @context_mock
      end
    end
  end
  
  describe "context recognition" do
    describe "context is a view" do
      before(:each) do
        @view_mock = flexmock(:view)
        @view_mock.should_receive(:controller).and_return 'controller'
        @representer = Representers::Base.new(nil, @view_mock)
      end
      it "should get the controller from the view" do
        @representer.controller.should == 'controller'
      end
    end
    describe "context is a controller" do
      before(:each) do
        @controller_mock = flexmock(:controller)
        @representer = Representers::Base.new(nil, @controller_mock)
      end
      it "should just use it for the controller" do
        @representer.controller.should == @controller_mock
      end
    end
  end
  
  class ModelReaderModel < Struct.new(:some_model_value); end
  describe ".model_reader" do
    before(:each) do
      @model = ModelReaderModel.new
      @representer = Representers::Base.new(@model, nil)
      class << @representer
        def a(s); s << 'a' end
        def b(s); s << 'b' end
      end
    end
    it "should call filters in a given pattern" do
      @model.some_model_value = 's'
      @representer.class.model_reader :some_model_value, :filter_through => [:a, :b, :a, :a]
    
      @representer.some_model_value.should == 'sabaa'
    end
    it "should pass through the model value if no filters are installed" do
      @model.some_model_value = :some_model_value
      @representer.class.model_reader :some_model_value
      
      @representer.some_model_value.should == :some_model_value
    end
  end
  
  describe ".master_helper_module" do
    before(:each) do
      class Representers::SpecificMasterHelperModule < Representers::Base; end
    end
    it "should be a class specific inheritable accessor" do
      Representers::SpecificMasterHelperModule.master_helper_module = :some_value
      Representers::SpecificMasterHelperModule.master_helper_module.should == :some_value
    end
    it "should be an instance of Module on Base" do
      Representers::Base.master_helper_module.should be_instance_of(Module)
    end
  end
  
  describe ".controller_method" do
    it "should set up delegate calls to the controller" do
      flexmock(Representers::Base).should_receive(:delegate).once.with(:method1, :to => :controller)
      flexmock(Representers::Base).should_receive(:delegate).once.with(:method2, :to => :controller)
      
      Representers::Base.controller_method :method1, :method2
    end
  end
  
  describe ".helper" do
    it "should include the helper" do
      helper_module = Module.new
      flexmock(Representers::Base).should_receive(:include).once.with helper_module
      
      Representers::Base.helper helper_module
    end
    it "should include the helper in the master helper module" do
      master_helper_module_mock = flexmock(:master_helper_module)
      flexmock(Representers::Base).should_receive(:master_helper_module).and_return master_helper_module_mock
      
      helper_module = Module.new
      master_helper_module_mock.should_receive(:include).once.with helper_module
      
      Representers::Base.helper helper_module
    end
  end
  
  describe ".presenter_path" do
    it "should call underscore on its name" do
      name_mock = flexmock(:name)
      flexmock(Representers::Base).should_receive(:name).once.and_return(name_mock)
      
      name_mock.should_receive(:underscore).once.and_return 'underscored_name'
      Representers::Base.representer_path.should == 'underscored_name'
    end
  end
  
  describe "#logger" do
    it "should delegate to the controller" do
      controller_mock = flexmock(:controller)
      representer = Representers::Base.new(nil, controller_mock)
      
      controller_mock.should_receive(:logger).once
      
      in_the representer do
        logger
      end
    end
  end
  
  describe "with mocked Presenter" do
    attr_reader :model_mock, :context_mock, :representer
    before(:each) do
      @model_mock = flexmock(:model)
      @context_mock = flexmock(:context)
      @representer = Representers::Base.new(model_mock, context_mock)
    end
    describe "#render_as" do
      before(:each) do
        @view_name = flexmock(:view_name)
        @view_instance_mock = flexmock(:view_instance)

        flexmock(representer).should_receive(:view_instance).once.and_return @view_instance_mock

        path_mock = flexmock(:path)
        flexmock(representer).should_receive(:template_path).once.with(@view_name).and_return path_mock

        @view_instance_mock.should_receive(:render).once.with(
          :partial => path_mock, :locals => { :representer => representer }
        )
      end
      it "should not call template_format=" do
        @view_instance_mock.should_receive(:template_format=).never

        representer.render_as(@view_name)
      end
      it "should call template_format=" do
        @view_instance_mock.should_receive(:template_format=).once.with(:some_format)

        representer.render_as(@view_name, :some_format)
      end
    end
    
    describe "#presenter_template_path" do
      describe "absolute path given" do
        it "should use it as given" do
          in_the representer do
            template_path('some/path/to/template').should == 'some/path/to/template'
          end
        end
      end
      describe "with just the template name" do
        it "should prepend the representer path" do
          flexmock(Representers::Base).should_receive(:representer_path).and_return('some/representer/path/to')
          
          in_the representer do
            template_path('template').should == 'some/representer/path/to/template'
          end
        end
      end
    end
    
    describe "#view_instance" do
      it "should create a new view instance from ActionView::Base" do
        view_paths_mock = flexmock(:view_paths)
        context_mock.should_receive('class.view_paths').once.and_return(view_paths_mock)
        
        flexmock(ActionView::Base).should_receive(:new).once.with(view_paths_mock, {}, @context_mock)
        in_the representer do
          view_instance
        end
      end
      it "should extend the view instance with the master helper module" do
        master_helper_module_mock = flexmock(:master_helper_module)
        flexmock(representer).should_receive(:master_helper_module).and_return(master_helper_module_mock)
        
        view_instance_mock = flexmock(:view_instance)
        view_instance_mock.should_receive(:extend).with(master_helper_module_mock)
        
        context_mock.should_receive('class.view_paths').once
        flexmock(ActionView::Base).should_receive(:new).once.and_return view_instance_mock
        
        in_the representer do
          view_instance
        end
      end
    end
  end
  
end