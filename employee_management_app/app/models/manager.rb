class Manager < ApplicationRecord
  has_many :employees, dependent: :nullify, inverse_of: :manager

  before_validation :normalize_email

  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, phone: true, allow_blank: true

  scope :alphabetical, -> { order(:last_name, :first_name) }

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
