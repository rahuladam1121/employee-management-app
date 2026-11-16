class Employee < ApplicationRecord
  belongs_to :manager, optional: true, inverse_of: :employees
  belongs_to :department, inverse_of: :employees

  before_validation :normalize_email

  validates :employee_number, presence: true, uniqueness: true
  validates :first_name, :last_name, :job_title, :joining_date, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, phone: true, allow_blank: true
  validates :salary, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :alphabetical, -> { order(:last_name, :first_name) }

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
