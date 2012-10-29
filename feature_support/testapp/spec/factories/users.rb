FactoryGirl.define do
  factory :user do |u|
    u.birth_date  { 24.years.ago }
    u.gender      true
    u.sequence(:name) {|i| "Elvis Presley No #{i}" }
  end
end