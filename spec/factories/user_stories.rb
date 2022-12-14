FactoryBot.define do
  factory :user_story do
    title { Faker::Lorem.sentence(word_count: 10) }
    description { Faker::Lorem.paragraph(sentence_count: 2, random_sentences_to_add: 3) }
    room
    estimation_value { nil }
    is_estimated { false }
  end
end
