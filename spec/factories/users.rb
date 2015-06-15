FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end
  factory :user do
    email
    password 'QwErTy!2#4%'
    password_confirmation 'QwErTy!2#4%'
  end

end
