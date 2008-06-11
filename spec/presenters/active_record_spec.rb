require File.join(File.dirname(__FILE__), '../spec_helper')

require 'active_record'

describe Presenters::ActiveRecord do
  
  describe "to_param" do
    attr_reader :model_mock, :presenter
    before(:each) do
      @model_mock = flexmock(:model)
      @presenter = Presenters::ActiveRecord.new(@model_mock, nil)
    end
    it "should delegate to the model" do
      model_mock.should_receive(:to_param).once
      
      presenter.to_param
    end
  end
  
end