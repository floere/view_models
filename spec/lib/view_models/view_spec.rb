require 'spec_helper'

describe ViewModels::View do
  subject do
    controller_class = stub :controller_class, :view_paths => ActionView::PathSet.new
    controller       = stub :controller, :class => controller_class, :_prefixes => nil

    ViewModels::View.new controller, Module.new
  end
  
  it "should be initializable" do
    lambda { subject }.should_not raise_error
  end
  
  it "should be renderable" do
    options = mock('options', :to_render_options => {:hey => 'hey!'})
    subject.should_receive(:render).with(:hey => 'hey!').once
    subject.render_with(options)
  end
  
  describe "finding templates" do
    let(:lookup_context) { mock('lookup_context') }
    let(:template) { mock('template') }

    before(:each) do
      subject.stub! :lookup_context => lookup_context
    end
    context "without ActionView Errors" do
      it "should find the template via lookup context" do
        lookup_context.should_receive(:find_template).with('PATH').once.and_return(template)
        subject.find_template('PATH').should == template
      end
    end
    context "with ActionView Errors" do
      it "should return nil" do
        lookup_context.should_receive(:find_template).with('PATH').once.and_raise(ActionView::MissingTemplate)
        subject.find_template('PATH').should be_nil
      end
    end
  end
  
end