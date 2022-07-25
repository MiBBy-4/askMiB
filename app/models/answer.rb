# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { minimum: 5 }

  def formatted_create_at
    created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end
