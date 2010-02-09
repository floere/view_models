require File.join(File.dirname(__FILE__), '../spec_helper')

require 'helpers/rails'

describe ViewModels::Helper::Rails do
  include ViewModels::Helper::Rails
  
  describe "collection_view_model_for" do
    it "should return kind of a ViewModels::Collection" do
      collection_view_model_for([]).should be_kind_of ViewModels::Helper::Rails::Collection
    end
    it "should pass any parameters directly through" do
      collection = stub :collection
      context = stub :context
      ViewModels::Helper::Rails::Collection.should_receive(:new).with(collection, context).once
      collection_view_model_for collection, context
    end
  end
  
  describe "view_model_for" do
    it "should just pass the params through to the view_model" do
      class SomeModelClazz; end
      class ViewModels::SomeModelClazz < ViewModels::Base; end
      context = stub :context
      self.stub! :default_view_model_class_for => ViewModels::SomeModelClazz
      model = SomeModelClazz.new
      
      ViewModels::SomeModelClazz.should_receive(:new).once.with model, context
      
      view_model_for model, context
    end
    describe "specific_view_model_mapping" do
      it "should return an empty hash by default" do
        specific_view_model_mapping.should == {}
      end
    end
    describe "no specific mapping" do
      it "should raise on a non-view_model instance" do
        class SomeNonViewModelClazz; end
        class ViewModels::SomeNonViewModelClazz; end
        lambda {
          view_model_for(SomeNonViewModelClazz.new)
        }.should raise_error(ViewModels::Helper::Rails::NotAViewModelError, 'ViewModels::SomeNonViewModelClazz is not a view_model.')
      end
      it "should raise on an non-mapped model" do
        lambda {
          view_model_for(42)
        }.should raise_error(ViewModels::Helper::Rails::MissingViewModelError, 'No view_model for Fixnum.')
      end
      it "should return a default view_model instance" do
        class SomeModelClazz; end
        class ViewModels::SomeModelClazz < ViewModels::Base; end
        view_model_for(SomeModelClazz.new).should be_instance_of ViewModels::SomeModelClazz
      end
    end
    describe "with specific mapping" do
      class SomeModelClazz; end
      class ViewModels::SomeSpecificClazz < ViewModels::Base; end
      before(:each) do
        self.should_receive(:specific_view_model_mapping).any_number_of_times.and_return SomeModelClazz => ViewModels::SomeSpecificClazz
      end
      it "should return a specifically mapped view_model instance" do
        view_model_for(SomeModelClazz.new).should be_instance_of ViewModels::SomeSpecificClazz
      end
      it "should not call #default_view_model_class_for" do
        mock(self).should_receive(:default_view_model_class_for).never
        view_model_for SomeModelClazz.new
      end
    end
  end
  
  describe "default_view_model_class_for" do
    it "should return a class with ViewModels:: prepended" do
      class Gaga; end # The model.
      class ViewModels::Gaga < ViewModels::Base; end
      default_view_model_class_for(Gaga.new).should == ViewModels::Gaga
    end
    it "should raise a NameError if the Presenter class does not exist" do
      class Brrzt; end # Just the model.
      lambda {
        default_view_model_class_for(Brrzt.new)
      }.should raise_error(NameError, "uninitialized constant ViewModels::Brrzt")
    end
  end
  
  describe ViewModels::Helper::Rails::Collection do
    
    before(:each) do
      @collection = stub :collection
      @context    = stub :context
      @collection_view_model = ViewModels::Helper::Rails::Collection.new @collection, @context
    end
    
    describe "list" do
      it "should call render_partial and return the rendered result" do
        @collection_view_model.stub! :render_partial => :result
        
        @collection_view_model.list.should == :result
      end
      it "should call render_partial with the right parameters" do
        default_options = {
          :collection => @collection,
          :context => @context,
          :template_name => :list_item,
          :separator => nil
        }
        
        @collection_view_model.should_receive(:render_partial).once.with :list, default_options
        
        @collection_view_model.list
      end
      it "should override the default options if specific options are given" do
        specific_options = {
          :collection => :a,
          :context => :b,
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
          :context => @context,
          :template_name => :collection_item,
          :separator => nil
        }
        @collection_view_model.should_receive(:render_partial).once.with :collection, default_options
        
        @collection_view_model.collection
      end
      it "should override the default options if specific options are given" do
        specific_options = {
          :collection => :a,
          :context => :b,
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
          :context => @context,
          :template_name => :table_row,
          :separator => nil
        }
        
        @collection_view_model.should_receive(:render_partial).once.with :table, default_options
        
        @collection_view_model.table
      end
      it "should override the default options if specific options are given" do
        specific_options = {
          :collection => :a,
          :context => :b,
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
          :context => @context,
          :separator => '|'
        }
        @collection_view_model.should_receive(:render_partial).once.with :pagination, default_options
        
        @collection_view_model.pagination
      end
      it "should override the default options if specific options are given" do
        specific_options = {
          :collection => :a,
          :context => :b,
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
  
end