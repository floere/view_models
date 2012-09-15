FactoryGirl.define do
  factory :hero do |h|
    h.birth_date  { 1000.years.ago }
    h.gender      false
    h.sequence(:name) {|i| "Thor No #{i}" }
  end
end