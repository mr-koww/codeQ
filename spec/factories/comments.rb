FactoryGirl.define do
  factory :comment do
    body 'My comments'
  end

  factory :invalid_comment do
    body nil
  end
end