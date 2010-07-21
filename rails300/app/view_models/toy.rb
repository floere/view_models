class ViewModels::Toy < ViewModels::Item
  
  model_reader :ages
  
  def description
    "For ages #{ages} and up."
  end
  
end