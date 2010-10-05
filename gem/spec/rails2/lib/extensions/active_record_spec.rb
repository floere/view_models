require File.expand_path File.join(File.dirname(__FILE__), '../../spec_helper')

describe ViewModels::Extensions::ActiveRecord do
  
  describe "to_param" do
    before(:each) do
      @model      = stub :model
      @view_model = ViewModels::Base.new @model, nil
      @view_model.extend ViewModels::Extensions::ActiveRecord
    end
    it "should delegate to_param to the model" do
      @model.should_receive(:to_param).once
      
      @view_model.to_param
    end
    
    it "should delegate id to the model" do
      @model.should_receive(:id).once
      
      @view_model.id
    end
    
    it "should delegate dom_id to ActionController::RecordIdentifier" do
      ActionController::RecordIdentifier.should_receive(:dom_id).once
      
      @view_model.dom_id
    end
    
  end
  
end