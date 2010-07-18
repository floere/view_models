class ExamplesController < ApplicationController
  
  def index
    @items = Items.all
  end
  
end
