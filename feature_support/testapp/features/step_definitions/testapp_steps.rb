Given /^the following (.+) exists?:$/ do |model, table|
  table.hashes.each do |hash|
    FactoryGirl.create(model.singularize.to_sym, hash)
  end
end
Given /^(.+) has stunned an international crowd$/ do |name|
  Hero.find_by_name(name).stun_international_crowd!
end
When /I visit (\w+) ([^']+)'s show page/ do |type, name|
  plurals = {'user' => 'users', 'hero' => 'heroes'}
  visit "/#{plurals[type]}/#{type.capitalize.constantize.find_by_name(name).id}"
end
Then /I should see "(.+)" within "(.+)"/ do |content, selector|
  puts page.html
  page.should have_css(selector, :text => content)
end