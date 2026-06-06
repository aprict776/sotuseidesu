FactoryBot.define do
  factory :memo do
    content { Faker::Lorem.sentence }
    association :user
  end
end
