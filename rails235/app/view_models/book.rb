class ViewModels::Book < ViewModels::Item
  
  model_reader :pages
  
  def description
    # This is to test the url_for helper.
    #
    # Note: Needed because for example Rails accesses @controller, which shared/base does not provide.
    #
    url_for self
    "It has #{pages} pages."
  end
  
end