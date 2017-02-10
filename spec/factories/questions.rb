FactoryGirl.define do
  sequence :title do |n|
    "Lorem ipsum dolor sit amet - #{n}"
  end

  factory :question do
    title
    body "Excepteur sint occaecat cupidatat non proident"
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
