require File.join(File.dirname(__FILE__), '../../spec_helper')

describe ViewModels::Helpers::Mapping do
  include ViewModels::Helpers::Mapping
  
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
      it "should raise an ArgumentError on an non-mapped model" do
        class SomeViewModelClass; end
        specific_view_model_mapping[String] = SomeViewModelClass
        lambda {
          view_model_for("Some String")
        }.should raise_error(ArgumentError, "wrong number of arguments (2 for 0)")
      end
    end
    describe "no specific mapping" do
      it "should raise on an non-mapped model" do
        lambda {
          view_model_for(42)
        }.should raise_error(NameError, "uninitialized constant ViewModels::Fixnum")
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
  
end