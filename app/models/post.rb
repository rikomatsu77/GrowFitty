class Post < ApplicationRecord
  belongs_to :user
  mount_uploader :post_image, PostImageUploader
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  attr_accessor :tag_names

  def save_post_tags(tags)
    current_tags = self.tags.pluck(:name)
    old_tags = current_tags - tags
    new_tags = tags - current_tags

    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name: old_name)
    end

    new_tags.each do |new_name|
      tag = Tag.find_or_create_by(name: new_name)
      self.tags << tag
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "title", "body" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "bookmarks", "post_tags", "tags", "user" ]
  end
end
