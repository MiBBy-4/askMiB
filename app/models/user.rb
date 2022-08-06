# frozen_string_literal: true

class User < ApplicationRecord
  include Recoverable
  include Rememberable

  attr_accessor :old_password, :admin_edit

  enum role: {
    basic: 0,
    moderator: 1,
    admin: 2
  }, _suffix: :role

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :password, confirmation: true, allow_blank: true, length: { minimum: 8, maximum: 70 }
  validate :password_complexity
  validate :password_presence
  validate :correct_old_password, on: :update, if: -> { password.present? && !admin_edit }

  has_secure_password validations: false

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  before_save :set_gravatar_hash, if: :email_changed?

  def author?(record)
    record.user == self
  end

  def guest?
    false
  end

  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  private

  def set_gravatar_hash
    return if email.blank?

    hash = Digest::MD5.hexdigest email.strip.downcase
    self.gravatar_hash = hash
  end

  def password_complexity
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/

    msg = 'complexity requirement not met. Length should be 8-70 characters and include: 1 uppercase, 1 lowercase,
                                                                                1 digit and 1 special character'
    errors.add :password, msg
  end

  def password_presence
    errors.add(:password, :blank) if password_digest.blank?
  end

  def correct_old_password
    return if BCrypt::Password.new(password_digest_was).is_password?(old_password)

    errors.add :old_password, 'uncorrect'
  end
end
