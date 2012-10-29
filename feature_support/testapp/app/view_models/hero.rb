class ViewModels::Hero < ViewModels::User
  
  def biography
    original = super
    return "Reactions provoked by " + name + " so far: " + original
  end
  
end