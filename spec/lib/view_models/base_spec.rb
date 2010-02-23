require File.join(File.dirname(__FILE__), '../../spec_helper')

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
    
  context "with mocked ViewModel" do
    before(:each) do
      @model = stub :model
      @context = stub :context
      @view_model = ViewModels::Base.new @model, @context
      
      @view_name = stub :view_name
      @view_instance = stub :view_instance
    end
    describe "#render_as" do
      before(:each) do
        @view_model.stub! :view_instance_for => @view_instance
        @path = stub :path
        @view_model.stub! :template_path => @path
        @view_instance.stub! :render
        @options = {}
      end
      it "should pass through the options" do
        @view_model.should_receive(:render).once.with @options
        
        @view_model.render_as @view_name, @options
      end
    end
    
    describe "#template_path" do
      before(:each) do
        @view_model_class = ViewModels::Base
      end
      context 'path store has key' do
        before(:each) do
          @path_store = { :some_key => 'some/path' }
          @view_model_class.stub :path_store => @path_store
        end
        it 'should return the path from the path store' do
          in_the @view_model_class do
            template_path(nil, :some_key).should == 'some/path'
          end
        end
      end
      context 'path store does not have key' do
        before(:each) do
          @path_store = {}
          @view_model_class.stub :path_store => @path_store
        end
        it 'should generate a path' do
          options = stub :options
          
          @view_model_class.should_receive(:generate_template_path_from).once.with options
          
          in_the @view_model_class do
            template_path options
          end
        end
      end
    end
    
  end
  
end