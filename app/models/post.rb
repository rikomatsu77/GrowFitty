class Post < ApplicationRecord
  belongs_to :user
  mount_uploader :post_image, PostImageUploader
  has_many :comments, dependent: :destroy

  has_many :bookmarks, dependent: :destroy
end
