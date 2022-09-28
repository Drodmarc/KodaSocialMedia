class JoinGroup < ApplicationRecord
  validates :state, :role, presence: true

  belongs_to :user
  belongs_to :group

  enum role: [:member, :moderator,:admin, :owner]

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :approved, :removed, :ignored, :leaved, :cancelled

    event :approve do
      transitions from: :pending, to: :approved
    end

    event :ignore do
      transitions from: :pending, to: :ignored
    end

    event :cancel do
      transitions from: :pending, to: :cancelled
    end

    event :remove do
      transitions from: :approved, to: :removed
    end

    event :leave do
      transitions from: :approved, to: :leaved
    end

    event :request do
      transitions from: [:removed, :ignored, :leaved, :cancelled], to: :pending
    end
  end
end