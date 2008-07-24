require File.join(File.dirname(__FILE__), '../spec_helper')

require 'active_record'

describe Representers::ActiveRecord do
  
  describe "to_param" do
    attr_reader :model_mock, :representer
    before(:each) do
      @model_mock = flexmock(:model)
      @representer = Representers::ActiveRecord.new(@model_mock, nil)
    end
    it "should delegate to the model" do
      model_mock.should_receive(:to_param).once
      
      representer.to_param
    end
  end
  
end