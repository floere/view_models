class ViewModels::Book < ViewModels::Item
  
  model_reader :pages
  
  def description
    "It has #{pages} pages."
  end
  
end