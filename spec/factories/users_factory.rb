FactoryGirl.define do
  factory :user, aliases: [:author] do
    name { Faker::Name.name }
    email { Faker::Internet.email.gsub(/@.+$/, '@alliants.com') }
    subscription_preference :subscribed
  end
end
