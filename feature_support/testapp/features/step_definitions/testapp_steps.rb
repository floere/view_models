Given /^the following (.+) exists?:$/ do |model, table|
  table.hashes.each do |hash|
    FactoryGirl.create(model.singularize.to_sym, hash)
  end
end
When /I visit ([^']+)'s show page/ do |name|
  visit "/users/#{User.find_by_name(name).id}"
end
Then /I should see "(.+)" within "(.+)"/ do |content, selector|
  page.should have_css(selector, :text => content)
end