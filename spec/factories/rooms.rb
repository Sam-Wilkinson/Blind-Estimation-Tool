FactoryBot.define do
  factory :room do
    name { Faker::Lorem.sentence }
    admin { create(:user) }
  end
end
