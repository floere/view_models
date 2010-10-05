require File.expand_path File.join(File.dirname(__FILE__), '/../../spec_helper')

describe ViewModels::View do
  
  it "should be initializable" do
    controller_class = stub :controller_class, :view_paths => ActionView::PathSet.new
    controller       = stub :controller, :class => controller_class
    
    ViewModels::View.new controller, Module.new
  end
  
end