FactoryGirl.define do
  factory :question do
    title "Default Title"
    body "Default Body"
  end

  factory :invalid_question, class: "Question"  do
    title nil
    body nil
  end
end
