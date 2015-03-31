FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "Default Title Question №#{n}" }
    sequence(:body) { |n| "Default Body Question № #{n}" }
  end

  factory :invalid_question, class: "Question"  do
    title nil
    body nil
  end
end