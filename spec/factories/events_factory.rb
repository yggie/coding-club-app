FactoryGirl.define do
  factory :event do
    sequence(:title) { |n| "Event-#{n}" }
    date { Date.tomorrow }
    sequence(:summary) { |n| "This is a summary of event-#{n}" }
  end
end
