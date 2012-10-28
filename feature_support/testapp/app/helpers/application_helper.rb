module ApplicationHelper
  
  def email_filter(email)
    email.gsub! /@/, '(at)'
    email
  end

end