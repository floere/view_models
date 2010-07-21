class ExamplesController < ApplicationController
  
  layout nil
  
  def index
    @items = Items.all
  end
  
end