class Group < ApplicationRecord
  validates :name, :image, :description, :privacy, presence: true
  belongs_to :user
  has_many :join_groups
  has_many :users, through: :join_groups

  enum privacy: [:visible, :hidden]
  mount_uploader :image, ImageUploader
end