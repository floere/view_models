require File.join(File.dirname(__FILE__), '../spec_helper')

require 'helpers/representer_helper'

describe RepresenterHelper do
  include RepresenterHelper
  
  describe "collection_representer_for" do
    it "should return kind of a Representers::Collection" do
      collection_representer_for([]).should be_kind_of(RepresenterHelper::Collection)
    end
    it "should pass any parameters directly through" do
      collection_mock = flexmock(:collection)
      context_mock = flexmock(:context)
      flexmock(RepresenterHelper::Collection).should_receive(:new).with(collection_mock, context_mock).once
      collection_representer_for(collection_mock, context_mock)
    end
  end
  
  describe "representer_for" do
    it "should just pass the params through to the representer" do
      class SomeModelClass; end
      class Representers::SomeModelClass < Representers::Base; end
      context_mock = flexmock(:context)
      representer_class_mock = flexmock(Representers::SomeModelClass)
      
      flexmock(self).should_receive(:default_representer_class_for).and_return representer_class_mock
      model = SomeModelClass.new
      
      representer_class_mock.should_receive(:new).once.with(model, context_mock)
      representer_for(model, context_mock)
    end
    describe "specific_representer_mapping" do
      it "should return an empty hash by default" do
        specific_representer_mapping.should == {}
      end
    end
    describe "no specific mapping" do
      it "should raise on a non-representer instance" do
        class SomeNonRepresenterClass; end
        class Representers::SomeNonRepresenterClass; end
        lambda {
          representer_for(SomeNonRepresenterClass.new)
        }.should raise_error(RepresenterHelper::NotARepresenterError, 'Representers::SomeNonRepresenterClass is not a representer.')
      end
      it "should raise on an non-mapped model" do
        lambda {
          representer_for(42)
        }.should raise_error(RepresenterHelper::MissingRepresenterError, 'No representer for Fixnum.')
      end
      it "should return a default representer instance" do
        class SomeModelClass; end
        class Representers::SomeModelClass < Representers::Base; end
        representer_for(SomeModelClass.new).should be_instance_of(Representers::SomeModelClass)
      end
    end
    describe "with specific mapping" do
      class SomeModelClass; end
      class Representers::SomeSpecificClass < Representers::Base; end
      before(:each) do
        flexmock(self).should_receive(:specific_representer_mapping).and_return(
          { SomeModelClass => Representers::SomeSpecificClass }
        )
      end
      it "should return a specifically mapped representer instance" do
        representer_for(SomeModelClass.new).should be_instance_of(Representers::SomeSpecificClass)
      end
      it "should not call #default_representer_class_for" do
        flexmock(self).should_receive(:default_representer_class_for).never
        representer_for(SomeModelClass.new)
      end
    end
  end
  
  describe "default_representer_class_for" do
    it "should return a class with Representers:: prepended" do
      class Gaga; end # The model.
      class Representers::Gaga < Representers::Base; end
      default_representer_class_for(Gaga.new).should == Representers::Gaga
    end
    it "should raise a NameError if the Presenter class does not exist" do
      class Brrzt; end # Just the model.
      lambda {
        default_representer_class_for(Brrzt.new)
      }.should raise_error(NameError, "uninitialized constant Representers::Brrzt")
    end
  end
  
  describe RepresenterHelper::Collection do

    attr_reader :collection_mock, :context_mock, :collection_representer

    before(:each) do
      @collection_mock = flexmock(:collection)
      @context_mock = flexmock(:context)
      @collection_representer = RepresenterHelper::Collection.new(@collection_mock, @context_mock)
    end

    describe "list" do
      it "should call render_partial and return the rendered result" do
        flexmock(collection_representer).should_receive(:render_partial).and_return(:result)

        collection_representer.list.should == :result
      end
      it "should call render_partial with the right parameters" do
        default_options = {
          :collection => collection_mock,
          :context => context_mock,
          :template_name => :list_item,
          :separator => nil
        }
        flexmock(collection_representer).should_receive(:render_partial).once.with('list', default_options)

        collection_representer.list
      end
      it "should override the default options if specific options are given" do
        specific_options = {
          :collection => :a,
          :context => :b,
          :template_name => :c,
          :separator => :d
        }
        flexmock(collection_representer).should_receive(:render_partial).once.with('list', specific_options)

        collection_representer.list(specific_options)
      end
    end

    describe "collection" do
      it "should call render_partial and return the rendered result" do
        flexmock(collection_representer).should_receive(:render_partial).and_return(:result)

        collection_representer.collection.should == :result
      end
      it "should call render_partial with the right parameters" do
        default_options = {
          :collection => collection_mock,
          :context => context_mock,
          :template_name => :collection_item,
          :separator => nil
        }
        flexmock(collection_representer).should_receive(:render_partial).once.with('collection', default_options)

        collection_representer.collection
      end
      it "should override the default options if specific options are given" do
        specific_options = {
          :collection => :a,
          :context => :b,
          :template_name => :c,
          :separator => :d
        }
        flexmock(collection_representer).should_receive(:render_partial).once.with('collection', specific_options)

        collection_representer.collection(specific_options)
      end
    end

    describe "table" do
      it "should call render_partial and return the rendered result" do
        flexmock(collection_representer).should_receive(:render_partial).and_return(:result)

        collection_representer.table.should == :result
      end
      it "should call render_partial with the right parameters" do
        default_options = {
          :collection => collection_mock,
          :context => context_mock,
          :template_name => :table_row,
          :separator => nil
        }
        flexmock(collection_representer).should_receive(:render_partial).once.with('table', default_options)

        collection_representer.table
      end
      it "should override the default options if specific options are given" do
        specific_options = {
          :collection => :a,
          :context => :b,
          :template_name => :c,
          :separator => :d
        }
        flexmock(collection_representer).should_receive(:render_partial).once.with('table', specific_options)

        collection_representer.table(specific_options)
      end
    end

    describe "pagination" do
      it "should call render_partial and return the rendered result" do
        flexmock(collection_representer).should_receive(:render_partial).and_return(:result)

        collection_representer.pagination.should == :result
      end
      it "should call render_partial with the right parameters" do
        default_options = {
          :collection => collection_mock,
          :context => context_mock,
          :separator => '|'
        }
        flexmock(collection_representer).should_receive(:render_partial).once.with('pagination', default_options)

        collection_representer.pagination
      end
      it "should override the default options if specific options are given" do
        specific_options = {
          :collection => :a,
          :context => :b,
          :separator => :c
        }
        flexmock(collection_representer).should_receive(:render_partial).once.with('pagination', specific_options)

        collection_representer.pagination(specific_options)
      end
    end

    describe "render_partial" do
      it "should call instance eval on the context" do
        context_mock.should_receive(:instance_eval).once

        collection_representer.send :render_partial, :some_name, :some_params
      end
      it "should render the partial in the 'context' context" do
        context_mock.should_receive(:render).once

        collection_representer.send :render_partial, :some_name, :some_params
      end
      it "should call render partial on context with the passed through parameters" do
        context_mock.should_receive(:render).once.with(:partial => 'representers/collection/some_name', :locals => { :a => :b })

        collection_representer.send :render_partial, 'some_name', { :a => :b }
      end
    end

  end
  
end