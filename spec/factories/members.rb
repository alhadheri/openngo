FactoryGirl.define do
  factory :member do
    name "member1"
  	gender 1
  	joined_at "2015-11-21"
  	email "test@example.com"
  	mobile "MyString"
  	address "MyString"
  	education 1
  	bio "MyText"
  	active true
    organization
  end
end
