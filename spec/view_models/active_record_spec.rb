require File.join(File.dirname(__FILE__), '../spec_helper')

require 'active_record'

describe ViewModels::ActiveRecord do
  
  describe "to_param" do
    attr_reader :model_mock, :view_model
    before(:each) do
      @model_mock = flexmock(:model)
      @view_model = ViewModels::ActiveRecord.new(@model_mock, nil)
    end
    it "should delegate to_param to the model" do
      model_mock.should_receive(:to_param).once
      view_model.to_param
    end
    
    it "should delegate id to the model" do
      model_mock.should_receive(:id).once
      view_model.id
    end
    
    it "should delegate dom_id to ActionController::RecordIdentifier" do
      flexmock(ActionController::RecordIdentifier).should_receive(:dom_id).once
      view_model.dom_id
    end
    
  end
  
end