require File.join(File.dirname(__FILE__), '../spec_helper')

require 'active_record'

describe Representers::ActiveRecord do
  
  describe "to_param" do
    attr_reader :model_mock, :representer
    before(:each) do
      @model_mock = flexmock(:model)
      @representer = Representers::ActiveRecord.new(@model_mock, nil)
    end
    it "should delegate to_param to the model" do
      model_mock.should_receive(:to_param).once
      representer.to_param
    end
    
    it "should delegate id to the model" do
      model_mock.should_receive(:id).once
      representer.id
    end
    
    it "should delegate dom_id to ActionController::RecordIdentifier" do
      flexmock(ActionController::RecordIdentifier).should_receive(:dom_id).once
      representer.dom_id
    end
    
  end
  
end