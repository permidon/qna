FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password '12345678'
    password_confirmation '12345678'
    confirmed_at DateTime.now
  end

  factory :admin, class: "User" do
    email
    password '12345678'
    password_confirmation '12345678'
    confirmed_at DateTime.now
    admin true
  end
end
