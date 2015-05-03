FactoryGirl.define do
  factory :comment do
    body 'My comments'
    user
  end

  factory :invalid_comment do
    body ""
  end
end