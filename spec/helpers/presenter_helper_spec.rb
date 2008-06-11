require File.join(File.dirname(__FILE__), '../spec_helper')

require 'helpers/presenter_helper'

describe PresenterHelper do
  include PresenterHelper
  
  describe "collection_presenter_for" do
    it "should return kind of a Presenters::Collection" do
      collection_presenter_for([]).should be_kind_of(PresenterHelper::Collection)
    end
    it "should pass any parameters directly through" do
      collection_mock = flexmock(:collection)
      context_mock = flexmock(:context)
      flexmock(PresenterHelper::Collection).should_receive(:new).with(collection_mock, context_mock).once
      collection_presenter_for(collection_mock, context_mock)
    end
  end
  
  describe "presenter_for" do
    it "should just pass the params through to the presenter" do
      class SomeModelClass; end
      class Presenters::SomeModelClass < Presenters::Base; end
      context_mock = flexmock(:context)
      presenter_class_mock = flexmock(Presenters::SomeModelClass)
      
      flexmock(self).should_receive(:default_presenter_class_for).and_return presenter_class_mock
      model = SomeModelClass.new
      
      presenter_class_mock.should_receive(:new).once.with(model, context_mock)
      presenter_for(model, context_mock)
    end
    describe "specific_presenter_mapping" do
      it "should return an empty hash by default" do
        specific_presenter_mapping.should == {}
      end
    end
    describe "no specific mapping" do
      it "should raise on a non-presenter instance" do
        class SomeNonPresenterClass; end
        class Presenters::SomeNonPresenterClass; end
        lambda {
          presenter_for(SomeNonPresenterClass.new)
        }.should raise_error(PresenterHelper::NotAPresenterError, 'Presenters::SomeNonPresenterClass is not a presenter.')
      end
      it "should raise on an non-mapped model" do
        lambda {
          presenter_for(42)
        }.should raise_error(PresenterHelper::MissingPresenterError, 'No presenter for Fixnum.')
      end
      it "should return a default presenter instance" do
        class SomeModelClass; end
        class Presenters::SomeModelClass < Presenters::Base; end
        presenter_for(SomeModelClass.new).should be_instance_of(Presenters::SomeModelClass)
      end
    end
    describe "with specific mapping" do
      class SomeModelClass; end
      class Presenters::SomeSpecificClass < Presenters::Base; end
      before(:each) do
        flexmock(self).should_receive(:specific_presenter_mapping).and_return(
          { SomeModelClass => Presenters::SomeSpecificClass }
        )
      end
      it "should return a specifically mapped presenter instance" do
        presenter_for(SomeModelClass.new).should be_instance_of(Presenters::SomeSpecificClass)
      end
      it "should not call #default_presenter_class_for" do
        flexmock(self).should_receive(:default_presenter_class_for).never
        presenter_for(SomeModelClass.new)
      end
    end
  end
  
  describe "default_presenter_class_for" do
    it "should return a class with Presenters:: prepended" do
      class Gaga; end # The model.
      class Presenters::Gaga < Presenters::Base; end
      default_presenter_class_for(Gaga.new).should == Presenters::Gaga
    end
    it "should raise a NameError if the Presenter class does not exist" do
      class Brrzt; end # Just the model.
      lambda {
        default_presenter_class_for(Brrzt.new)
      }.should raise_error(NameError, "uninitialized constant Presenters::Brrzt")
    end
  end
  
  describe PresenterHelper::Collection do

    attr_reader :collection_mock, :context_mock, :collection_presenter

    before(:each) do
      @collection_mock = flexmock(:collection)
      @context_mock = flexmock(:context)
      @collection_presenter = PresenterHelper::Collection.new(@collection_mock, @context_mock)
    end

    describe "list" do
      it "should call render_partial and return the rendered result" do
        flexmock(collection_presenter).should_receive(:render_partial).and_return(:result)

        collection_presenter.list.should == :result
      end
      it "should call render_partial with the right parameters" do
        default_options = {
          :collection => collection_mock,
          :context => context_mock,
          :template_name => :list_item,
          :separator => nil
        }
        flexmock(collection_presenter).should_receive(:render_partial).once.with('list', default_options)

        collection_presenter.list
      end
      it "should override the default options if specific options are given" do
        specific_options = {
          :collection => :a,
          :context => :b,
          :template_name => :c,
          :separator => :d
        }
        flexmock(collection_presenter).should_receive(:render_partial).once.with('list', specific_options)

        collection_presenter.list(specific_options)
      end
    end

    describe "collection" do
      it "should call render_partial and return the rendered result" do
        flexmock(collection_presenter).should_receive(:render_partial).and_return(:result)

        collection_presenter.collection.should == :result
      end
      it "should call render_partial with the right parameters" do
        default_options = {
          :collection => collection_mock,
          :context => context_mock,
          :template_name => :collection_item,
          :separator => nil
        }
        flexmock(collection_presenter).should_receive(:render_partial).once.with('collection', default_options)

        collection_presenter.collection
      end
      it "should override the default options if specific options are given" do
        specific_options = {
          :collection => :a,
          :context => :b,
          :template_name => :c,
          :separator => :d
        }
        flexmock(collection_presenter).should_receive(:render_partial).once.with('collection', specific_options)

        collection_presenter.collection(specific_options)
      end
    end

    describe "table" do
      it "should call render_partial and return the rendered result" do
        flexmock(collection_presenter).should_receive(:render_partial).and_return(:result)

        collection_presenter.table.should == :result
      end
      it "should call render_partial with the right parameters" do
        default_options = {
          :collection => collection_mock,
          :context => context_mock,
          :template_name => :table_row,
          :separator => nil
        }
        flexmock(collection_presenter).should_receive(:render_partial).once.with('table', default_options)

        collection_presenter.table
      end
      it "should override the default options if specific options are given" do
        specific_options = {
          :collection => :a,
          :context => :b,
          :template_name => :c,
          :separator => :d
        }
        flexmock(collection_presenter).should_receive(:render_partial).once.with('table', specific_options)

        collection_presenter.table(specific_options)
      end
    end

    describe "pagination" do
      it "should call render_partial and return the rendered result" do
        flexmock(collection_presenter).should_receive(:render_partial).and_return(:result)

        collection_presenter.pagination.should == :result
      end
      it "should call render_partial with the right parameters" do
        default_options = {
          :collection => collection_mock,
          :context => context_mock,
          :separator => '|'
        }
        flexmock(collection_presenter).should_receive(:render_partial).once.with('pagination', default_options)

        collection_presenter.pagination
      end
      it "should override the default options if specific options are given" do
        specific_options = {
          :collection => :a,
          :context => :b,
          :separator => :c
        }
        flexmock(collection_presenter).should_receive(:render_partial).once.with('pagination', specific_options)

        collection_presenter.pagination(specific_options)
      end
    end

    describe "render_partial" do
      it "should call instance eval on the context" do
        context_mock.should_receive(:instance_eval).once

        collection_presenter.send :render_partial, :some_name, :some_params
      end
      it "should render the partial in the 'context' context" do
        context_mock.should_receive(:render).once

        collection_presenter.send :render_partial, :some_name, :some_params
      end
      it "should call render partial on context with the passed through parameters" do
        context_mock.should_receive(:render).once.with(:partial => 'presenters/collection/some_name', :locals => { :a => :b })

        collection_presenter.send :render_partial, 'some_name', { :a => :b }
      end
    end

  end
  
end