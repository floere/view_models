require File.expand_path '../../spec_helper', File.dirname(__FILE__)

describe ViewModels::Helpers::Mapping::Collection do
  include ViewModels::Helpers::Mapping
  
  before(:each) do
    @collection = stub :collection
    @context    = stub :context
    @collection_view_model = ViewModels::Helpers::Mapping::Collection.new @collection, @context
  end
  
  describe "render_partial" do
    it "should call instance eval on the context" do
      @context.should_receive(:instance_eval).once
      
      @collection_view_model.send :render_partial, :some_name, :some_params
    end
    it "should render the partial in the 'context' context" do
      @context.should_receive(:render).once
      
      @collection_view_model.send :render_partial, :some_name, :some_params
    end
    it "should call render partial on context with the passed through parameters" do
      @context.should_receive(:render).once.with('view_models/collection/_some_name', :locals => { :a => :b })
      
      @collection_view_model.send :render_partial, :some_name, { :a => :b }
    end
  end
  
end