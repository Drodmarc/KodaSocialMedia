class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, :class_name => 'User'

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :confirmed, :unfriended, :cancelled, :ignored

    event :confirm do
      transitions from: :pending, to: :confirmed
    end

    event :unfriend do
      transitions from: :confirmed, to: :unfriended
    end

    event :cancel do
      transitions from: :pending, to: :cancelled
    end

    event :ignore do
      transitions from: :pending, to: :ignored
    end

    event :request do
      transitions from: [:unfriended, :cancelled, :ignored], to: :pending
    end
  end
end