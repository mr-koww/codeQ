FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "Default Answer № #{n}" }
    user nil
    question nil
  end

end
