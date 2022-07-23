# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true

  def formatted_create_at
    created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end
