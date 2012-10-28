require 'spec_helper'

describe ViewModels::Extensions::ModelReader do

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
      @view_model.class.model_reader :some_model_value, :filter_through => [:a, :b, :a, :a]
    
      @view_model.some_model_value.should == 'sabaa'
    end
    it "should handle a single filter" do
      @view_model.class.model_reader :some_model_value, :filter_through => :a
    
      lambda { @view_model.some_model_value }.should_not raise_error
    end
    it "should handle multiple readers" do
      @view_model.class.model_reader :some_model_value, :some_other_model_value, :filter_through => :a
    
      lambda { @view_model.some_model_value }.should_not raise_error
    end
  end
  
  describe 'FilteredDelegationInstaller' do
    before(:each) do
      @model = ModelReaderModel.new
    end
    context 'with filters' do
      before(:each) do
        @options = ViewModels::Extensions::ModelReader::Options.new :some_attribute_name, :filter_through => [:filter1, :filter2]
        @installer = ViewModels::Extensions::ModelReader::FilteredDelegationInstaller.new @model, @options
      end
      it 'should have a correct filter definition' do
        @installer.reader_definition_for(:some_attribute).should == 'def some_attribute; filter2(filter1(model.some_attribute)); end'
      end
    end
    context 'without filters' do
      before(:each) do
        @options = ViewModels::Extensions::ModelReader::Options.new :some_attribute_name
        @installer = ViewModels::Extensions::ModelReader::FilteredDelegationInstaller.new @model, @options
      end
      it 'should have a correct filter definition' do
        @installer.reader_definition_for(:some_attribute).should == 'def some_attribute; model.some_attribute; end'
      end
    end
  end
  
  describe 'Options' do
    context 'without filters' do
      before(:each) do
        @options = ViewModels::Extensions::ModelReader::Options.new :some_attribute_name
      end
      describe 'split' do
        it 'should return the right values' do
          @options.to_a.should == [[:some_attribute_name], []]
        end
      end
    end
    context 'with filters' do
      before(:each) do
        @options = ViewModels::Extensions::ModelReader::Options.new :some_attribute_name, :filter_through => [:filter1, :filter2]
      end
      describe 'split' do
        it 'should return the right values, with flipped options' do
          @options.to_a.should == [[:some_attribute_name], [:filter2, :filter1]]
        end
      end
    end
  end
  
end