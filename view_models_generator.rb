class BasicAuthGenerator < Rails::Generator::Base
  def manifest
    
    record do |m|
      
      # ViewModels
      m.directory 'app/view_models'
      m.template "view_models/view_model.rb", "app/view_models/#{file_name}.rb"
      
      # Specs
      m.file "test/unit/user_test.rb", "test/unit/user_test.rb"
      
      # Views
      m.directory "app/views/view_models"
      m.file "views/view_model.html.haml", "app/views/view_models/#{file_name}/_some_partial.html.haml"
      
      # Copy collection views.
      
      
      m.readme "README"
      
    end
  end

  def file_name
    "create_users"
  end

end