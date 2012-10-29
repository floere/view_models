class ViewModels::User < ViewModels::Test
  
  model_reader :name, :biography, :filter_through => [:h]
  model_reader :email, :filter_through => [:email_filter, :h]
  
  def age
    Date.today.year - model.birth_date.year
  end
  
  def humanized_gender
    model.gender ? 'woman' : 'man'
  end
  
end