# A generator for view models
#
class ViewModelsGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  argument :class_name, :type => :string
  class_option :views, :type => :string, :default => 'erb', :desc => "Render view files in erb, haml or slim (use the language name as the argument)"

  # Generate the view models given
  #
  def generate_view_models
    file_name = class_name.underscore
    
    create_model class_name, file_name
    
    create_views file_name if options.views.present?
  end
  
  # Create views corresponding to view models
  #
  def create_views file_name
    %W(list_item main_item).each do |view|
      create_file "app/views/#{file_name.pluralize}/_#{view}.html.#{options.views.downcase}", File.read(File.join(File.expand_path('../templates', __FILE__), "/views/_empty.html.#{options.views.downcase}"))
    end
  
    # Copy collection views.
    #
    %W(collection list pagination table).each do |view|
      create_file "app/views/#{file_name.pluralize}/_#{view}.html.#{options.views.downcase}", File.read(File.join(File.expand_path('../templates', __FILE__), "/views/_#{view}.html.#{options.views.downcase}"))
    end
  end
  
  # Create the view model files for the view models given
  #
  def create_model class_name, file_name
    # ViewModels
    #
    create_file "app/view_models/#{file_name}.rb", <<-FILE
class ViewModels::#{class_name} < ViewModels::Project

# model_reader :icon, :filter_through => [:h]

end
    FILE

    # Specs
    #
    
    create_file "spec/view_models/#{file_name}_spec.rb", <<-FILE
require 'spec_helper'

describe ViewModels::#{class_name} do

end
    FILE

  end
end