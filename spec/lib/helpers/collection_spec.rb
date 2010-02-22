require File.join(File.dirname(__FILE__), '../../spec_helper')

describe ViewModels::Helpers::Rails::Collection do
  
  before(:each) do
    @collection = stub :collection
    @context    = stub :context
    @collection_view_model = ViewModels::Helpers::Rails::Collection.new @collection, @context
  end
  
  describe "list" do
    it "should call render_partial and return the rendered result" do
      @collection_view_model.stub! :render_partial => :result
      
      @collection_view_model.list.should == :result
    end
    it "should call render_partial with the right parameters" do
      default_options = {
        :collection => @collection,
        :template_name => :list_item,
        :separator => nil
      }
      
      @collection_view_model.should_receive(:render_partial).once.with :list, default_options
      
      @collection_view_model.list
    end
    it "should override the default options if specific options are given" do
      specific_options = {
        :collection => :a,
        :template_name => :c,
        :separator => :d
      }
      
      @collection_view_model.should_receive(:render_partial).once.with :list, specific_options
      
      @collection_view_model.list specific_options
    end
  end
  
  describe "collection" do
    it "should call render_partial and return the rendered result" do
      @collection_view_model.stub! :render_partial => :result
      
      @collection_view_model.collection.should == :result
    end
    it "should call render_partial with the right parameters" do
      default_options = {
        :collection => @collection,
        :template_name => :collection_item,
        :separator => nil
      }
      @collection_view_model.should_receive(:render_partial).once.with :collection, default_options
      
      @collection_view_model.collection
    end
    it "should override the default options if specific options are given" do
      specific_options = {
        :collection => :a,
        :template_name => :c,
        :separator => :d
      }
      
      @collection_view_model.should_receive(:render_partial).once.with :collection, specific_options
      
      @collection_view_model.collection specific_options
    end
  end
  
  describe "table" do
    it "should call render_partial and return the rendered result" do
      @collection_view_model.stub! :render_partial => :result
      
      @collection_view_model.table.should == :result
    end
    it "should call render_partial with the right parameters" do
      default_options = {
        :collection => @collection,
        :template_name => :table_row,
        :separator => nil
      }
      
      @collection_view_model.should_receive(:render_partial).once.with :table, default_options
      
      @collection_view_model.table
    end
    it "should override the default options if specific options are given" do
      specific_options = {
        :collection => :a,
        :template_name => :c,
        :separator => :d
      }
      
      @collection_view_model.should_receive(:render_partial).once.with :table, specific_options
      
      @collection_view_model.table(specific_options)
    end
  end
  
  describe "pagination" do
    it "should call render_partial and return the rendered result" do
      @collection_view_model.stub! :render_partial => :result
      
      @collection_view_model.pagination.should == :result
    end
    it "should call render_partial with the right parameters" do
      default_options = {
        :collection => @collection,
        :separator => '|'
      }
      @collection_view_model.should_receive(:render_partial).once.with :pagination, default_options
      
      @collection_view_model.pagination
    end
    it "should override the default options if specific options are given" do
      specific_options = {
        :collection => :a,
        :separator => :c
      }
      @collection_view_model.should_receive(:render_partial).once.with :pagination, specific_options
      
      @collection_view_model.pagination specific_options
    end
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
      @context.should_receive(:render).once.with(:partial => 'view_models/collection/some_name', :locals => { :a => :b })
      
      @collection_view_model.send :render_partial, :some_name, { :a => :b }
    end
  end
  
  describe "delegation" do
    describe "enumerable" do
      Enumerable.instance_methods.map(&:to_sym).each do |method|
        it "should delegate #{method} to the collection" do
          @collection.should_receive(method).once
          
          @collection_view_model.send method
        end
      end
    end
    describe "array" do
      describe "length" do
        it "should delegate to #length of the collection" do
          @collection.should_receive(:length).once
          
          @collection_view_model.length
        end
        it "should return the length of the collection" do
          @collection.should_receive(:length).and_return :this_length
          
          @collection_view_model.length.should == :this_length
        end
        it "should alias size" do
          @collection.should_receive(:size).and_return :this_length
          
          @collection_view_model.size.should == :this_length
        end
      end
      describe "empty?" do
        it "should delegate to #empty? of the collection" do
          @collection.should_receive(:empty?).once
          
          @collection_view_model.empty?
        end
        it "should return whatever #empty? of the collection returns" do
          @collection.should_receive(:empty?).and_return :true_or_false
          
          @collection_view_model.empty?.should == :true_or_false
        end
      end
      describe "each" do
        it "should delegate to #each of the collection" do
          proc = stub :proc
          
          @collection.should_receive(:each).with(proc).once
          
          @collection_view_model.each proc
        end
      end
    end
  end
  
end