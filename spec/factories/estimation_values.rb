FactoryBot.define do
  factory :estimation_value do
    value { Faker::Number.number(digits: 3) }
    placement { Faker::Number.unique.number(digits: 2) }
  end
end
