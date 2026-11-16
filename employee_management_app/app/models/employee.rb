class Employee < ApplicationRecord
  belongs_to :manager, class_name: "Employee", optional: true, inverse_of: :subordinates
  has_many :subordinates, class_name: "Employee", foreign_key: :manager_id,
                          dependent: :nullify, inverse_of: :manager

  before_validation :normalize_email

  validates :employee_number, presence: true, uniqueness: true
  validates :first_name, :last_name, :department, :job_title, :joining_date, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :salary, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validate :manager_cannot_be_self
  validate :manager_cannot_create_cycle

  scope :alphabetical, -> { order(:last_name, :first_name) }

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end

  def manager_cannot_be_self
    errors.add(:manager, "cannot be the employee themselves") if manager_id.present? && manager_id == id
  end

  def manager_cannot_create_cycle
    return if manager.nil? || new_record?

    current = manager
    visited_ids = []
    while current
      if current.id == id || visited_ids.include?(current.id)
        errors.add(:manager, "would create a reporting cycle")
        break
      end
      visited_ids << current.id
      current = current.manager
    end
  end
end
