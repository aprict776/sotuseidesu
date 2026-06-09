FactoryBot.define do
  factory :creation do
    title { Faker::Book.title }
    association :user
  end
end