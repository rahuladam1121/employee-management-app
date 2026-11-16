class Department < ApplicationRecord
  has_many :employees, dependent: :restrict_with_error, inverse_of: :department

  before_validation { self.name = name.to_s.strip }

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
