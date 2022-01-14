FactoryBot.define do
  factory :user do
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    password { 'testtest' }

    factory :user_with_rooms do
      transient do
        rooms_count { 2 }
      end

      after(:create) do |user, evaluator|
        create_list(:room, evaluator.rooms_count, admin: user)
      end
    end
  end
end
