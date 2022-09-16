class Post < ApplicationRecord
  validates :content, :genre, presence: true
  belongs_to :user

  mount_uploader :image, ImageUploader

  enum genre: [:to_all, :friends, :only_me]
end