FactoryGirl.define do
  sequence :body do |n|
    "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris - #{n}"
  end

  factory :answer do
    body
    question
  end

  factory :invalid_answer, class: "Answer" do
    body nil
    question
  end
end
