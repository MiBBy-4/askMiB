# frozen_string_literal: true

class Question < ApplicationRecord
  include Commentable
  include Authorship

  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :question_tags, dependent: :destroy
  has_many :tags, through: :question_tags

  validates :title, presence: true
  validates :body, presence: true

  scope :all_by_tags, lambda { |tags|
    questions = includes(:user)
    questions = if tags
                  questions.joins(:tags).where(tags: tags).preload(:tags)
                else
                  questions.includes(:question_tags, :tags)
                end
    questions.order(created_at: :desc)
  }

  def formatted_create_at
    created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end
