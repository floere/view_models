require File.join(File.dirname(__FILE__), '../spec_helper')

require 'presenters/base'

describe Presenters::Base do
  
  describe "readers" do
    describe "model" do
      before(:each) do
        @model_mock = flexmock(:model)
        @presenter = Presenters::Base.new(@model_mock, nil)
      end
      it "should have a reader" do
        @presenter.model.should == @model_mock
      end
    end
    describe "controller" do
      before(:each) do
        @context_mock = flexmock(:controller)
        @presenter = Presenters::Base.new(nil, @context_mock)
      end
      it "should have a reader" do
        @presenter.controller.should == @context_mock
      end
    end
  end
  
  describe "context recognition" do
    describe "context is a view" do
      before(:each) do
        @view_mock = flexmock(:view)
        @view_mock.should_receive(:controller).and_return 'controller'
        @presenter = Presenters::Base.new(nil, @view_mock)
      end
      it "should get the controller from the view" do
        @presenter.controller.should == 'controller'
      end
    end
    describe "context is a controller" do
      before(:each) do
        @controller_mock = flexmock(:controller)
        @presenter = Presenters::Base.new(nil, @controller_mock)
      end
      it "should just use it for the controller" do
        @presenter.controller.should == @controller_mock
      end
    end
  end
  
  class ModelReaderModel < Struct.new(:some_model_value); end
  describe ".model_reader" do
    before(:each) do
      @model = ModelReaderModel.new
      @presenter = Presenters::Base.new(@model, nil)
      class << @presenter
        def a(s); s << 'a' end
        def b(s); s << 'b' end
      end
    end
    it "should call filters in a given pattern" do
      @model.some_model_value = 's'
      @presenter.class.model_reader :some_model_value, :filter_through => [:a, :b, :a, :a]
    
      @presenter.some_model_value.should == 'sabaa'
    end
    it "should pass through the model value if no filters are installed" do
      @model.some_model_value = :some_model_value
      @presenter.class.model_reader :some_model_value
      
      @presenter.some_model_value.should == :some_model_value
    end
  end
  
  describe ".master_helper_module" do
    before(:each) do
      class Presenters::SpecificMasterHelperModule < Presenters::Base; end
    end
    it "should be a class specific inheritable accessor" do
      Presenters::SpecificMasterHelperModule.master_helper_module = :some_value
      Presenters::SpecificMasterHelperModule.master_helper_module.should == :some_value
    end
    it "should be an instance of Module on Base" do
      Presenters::Base.master_helper_module.should be_instance_of(Module)
    end
  end
  
  describe ".controller_method" do
    it "should set up delegate calls to the controller" do
      flexmock(Presenters::Base).should_receive(:delegate).once.with(:method1, :to => :controller)
      flexmock(Presenters::Base).should_receive(:delegate).once.with(:method2, :to => :controller)
      
      Presenters::Base.controller_method :method1, :method2
    end
  end
  
  describe ".helper" do
    it "should include the helper" do
      helper_module = Module.new
      flexmock(Presenters::Base).should_receive(:include).once.with helper_module
      
      Presenters::Base.helper helper_module
    end
    it "should include the helper in the master helper module" do
      master_helper_module_mock = flexmock(:master_helper_module)
      flexmock(Presenters::Base).should_receive(:master_helper_module).and_return master_helper_module_mock
      
      helper_module = Module.new
      master_helper_module_mock.should_receive(:include).once.with helper_module
      
      Presenters::Base.helper helper_module
    end
  end
  
  describe ".presenter_path" do
    it "should call underscore on its name" do
      name_mock = flexmock(:name)
      flexmock(Presenters::Base).should_receive(:name).once.and_return(name_mock)
      
      name_mock.should_receive(:underscore).once.and_return 'underscored_name'
      Presenters::Base.presenter_path.should == 'underscored_name'
    end
  end
  
  describe "#logger" do
    it "should delegate to the controller" do
      controller_mock = flexmock(:controller)
      presenter = Presenters::Base.new(nil, controller_mock)
      
      controller_mock.should_receive(:logger).once
      
      in_the presenter do
        logger
      end
    end
  end
  
  describe "#render_as" do
    before(:each) do
      model_mock = flexmock(:model)
      context_mock = flexmock(:context)
      @presenter = Presenters::Base.new(model_mock, context_mock)
      
      @view_name = flexmock(:view_name)
      @view_instance_mock = flexmock(:view_instance)
      
      flexmock(@presenter).should_receive(:view_instance).once.and_return @view_instance_mock
      
      path_mock = flexmock(:path)
      flexmock(@presenter).should_receive(:template_path).once.with(@view_name).and_return path_mock
      
      @view_instance_mock.should_receive(:render).once.with(
        :partial => path_mock, :locals => { :presenter => @presenter }
      )
    end
    it "should not call template_format=" do
      @view_instance_mock.should_receive(:template_format=).never
      
      @presenter.render_as(@view_name)
    end
    it "should call template_format=" do
      @view_instance_mock.should_receive(:template_format=).once.with(:some_format)
      
      @presenter.render_as(@view_name, :some_format)
    end
  end
  
  describe "with mocked Presenter" do
    attr_reader :model_mock, :context_mock, :presenter
    before(:each) do
      @model_mock = flexmock(:model)
      @context_mock = flexmock(:context)
      @presenter = Presenters::Base.new(model_mock, context_mock)
    end
    describe "#presenter_template_path" do
      describe "absolute path given" do
        it "should use it as given" do
          presenter.template_path('some/path/to/template').should == 'some/path/to/template'
        end
      end
      describe "with just the template name" do
        it "should prepend the presenter path" do
          flexmock(Presenters::Base).should_receive(:presenter_path).and_return('some/presenter/path/to')
          
          presenter.template_path('template').should == 'some/presenter/path/to/template'
        end
      end
    end
    
    describe "#view_instance" do
      it "should create a new view instance from ActionView::Base" do
        view_paths_mock = flexmock(:view_paths)
        @context_mock.should_receive('class.view_paths').once.and_return(view_paths_mock)
        
        flexmock(ActionView::Base).should_receive(:new).once.with(view_paths_mock, {}, @context_mock)
        @presenter.view_instance
      end
      it "should extend the view instance with the master helper module" do
        master_helper_module_mock = flexmock(:master_helper_module)
        flexmock(@presenter).should_receive(:master_helper_module).and_return(master_helper_module_mock)
        
        view_instance_mock = flexmock(:view_instance)
        view_instance_mock.should_receive(:extend).with(master_helper_module_mock)
        
        @context_mock.should_receive('class.view_paths').once
        flexmock(ActionView::Base).should_receive(:new).once.and_return view_instance_mock
        
        @presenter.view_instance
      end
    end
  end
  
end