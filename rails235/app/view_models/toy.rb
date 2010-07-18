class ViewModels::Toy < ViewModels::Item
  
  model_reader :ages
  
  def description
    "From ages #{ages} and up."
  end
  
end