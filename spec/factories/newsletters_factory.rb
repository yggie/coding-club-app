FactoryGirl.define do
  factory :newsletter do
    subject { Faker::Company.catch_phrase }
    body { Faker::Lorem.sentences(3) }
    sent_at nil
    author
  end
end
