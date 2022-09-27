class Group < ApplicationRecord
  validates :name, :image, :description, :privacy, presence: true
  belongs_to :user

  enum privacy: [:visible, :hidden]
  mount_uploader :image, ImageUploader
end