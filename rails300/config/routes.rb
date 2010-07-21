Rails300::Application.routes.draw do |map|
  
  map.resource :view_models do |vm|
    vm.resource :book
  end
  
  map.connect ':controller/:action'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
end
