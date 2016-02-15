require 'faker'

unique_auth0_id = 0

FactoryGirl.define do
  factory :user do |f|
    f.username { Faker::Internet.user_name }
    f.auth0_id { "#{unique_auth0_id += 1}" }
  end
end
