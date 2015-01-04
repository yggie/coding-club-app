FactoryGirl.define do
  factory :newsletter do
    subject { Faker::Company.catch_phrase }
    body { Faker::Lorem.sentences(3) }
    target_date { Time.now + 3.days }
    sent_at nil
  end
end
