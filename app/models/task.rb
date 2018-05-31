class Task < ApplicationRecord
  # Validations
  validates :user_id, presence: true
  validates :description, presence: true
  validates :datetime, presence: true
  validates :finished, exclusion: { in: [nil] }
  validates :important, exclusion: { in: [nil] }

  # Scopes
  default_scope { order(datetime: :asc) }
end
