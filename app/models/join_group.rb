class JoinGroup < ApplicationRecord
  validates :state, :role, presence: true

  belongs_to :user
  belongs_to :group

  enum role: [:owner, :admin, :moderator, :member]

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :approved, :removed, :ignored, :leaved

    event :approved do
      transitions from: :pending, to: :approved
    end

    event :ignored do
      transitions from: :pending, to: :ignored
    end

    event :removed do
      transitions from: :approved, to: :removed
    end

    event :leaved do
      transitions from: :approved, to: :leaved
    end
  end
end