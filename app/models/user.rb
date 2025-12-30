class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2, :line ]

  has_many :children, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_posts, through: :bookmarks, source: :post

  has_many :line_conversations, dependent: :destroy

  def own?(object)
    id == object&.user_id
  end

  validates :uid, presence: true, uniqueness: { scope: :provider }, if: :oauth_user?
  validates :email, presence: true, unless: -> { provider.present? }
  validates :email, uniqueness: true

  def oauth_user?
    provider.present?
  end

  def self.from_omniauth(auth)
  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.provider = auth.provider
    user.uid = auth.uid

      # メールアドレスの処理（LINEは提供しない場合があるため）
      if auth.info.email.present?
        user.email = auth.info.email
      else
        # LINEの場合、ダミーメールアドレスを生成
        user.email = "#{auth.provider}-#{auth.uid}@example.com"
      end

    user.password = Devise.friendly_token[0, 20]
    end
  end

  def self.create_unique_string
    SecureRandom.uuid
  end

  def bookmark(post)
    bookmark_posts << post
  end

  def unbookmark(post)
    bookmark_posts.destroy(post)
  end

  def bookmark?(post)
    bookmark_posts.include?(post)
  end
end
