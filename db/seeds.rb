# frozen_string_literal: true

30.times do
  question_title = Faker::Hipster.sentence(word_count: 3)
  question_body = Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 4)
  Question.create title: question_title, body: question_body
end

User.find_each do |user|
  user.send(:set_gravatar_hash) 
  user.save
end
