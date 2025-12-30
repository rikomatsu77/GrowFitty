require "rails_helper"

RSpec.describe User, type: :model do
  # アソシエーションのテスト
  describe "associations" do
    it { should have_many(:children).dependent(:destroy) }
    it { should have_many(:posts).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:bookmarks).dependent(:destroy) }
    it { should have_many(:bookmark_posts).through(:bookmarks).source(:post) }
    it { should have_many(:line_conversations).dependent(:destroy) }
  end

  # バリデーションのテスト
  describe "validations" do
    context "通常のユーザー（メール/パスワード認証）" do
      let(:user) { build(:user) }

      it "メールアドレスがあれば有効" do
        expect(user).to be_valid
      end

      it "メールアドレスがなければ無効" do
        user.email = nil
        expect(user).not_to be_valid
        expect(user.errors[:email]).to be_present
      end

      it "メールアドレスが重複していれば無効" do
        create(:user, email: "duplicate@example.com")
        user.email = "duplicate@example.com"
        expect(user).not_to be_valid
        expect(user.errors[:email]).to be_present
      end
    end

    context "OAuthユーザー（Google）" do
      let(:user) { build(:user, :google_oauth) }

      it "providerとuidがあれば有効"do
        expect(user).to be_valid
      end

      it "uidがなければ無効" do
        user.uid = nil
        expect(user).not_to be_valid
        expect(user.errors[:uid]).to be_present
      end

      it "同じprovider内でuidが重複していれば無効" do
        create(:user, provider: "google_oauth2", uid: "duplicate_uid")
        user.uid = "duplicate_uid"
        expect(user).not_to be_valid
        expect(user.errors[:uid]).to be_present
      end

      it "異なるproviderであれば同じuidでも有効" do
        create(:user, provider: "line", uid: "same_uid")
        user.provider = "google_oauth2"
        user.uid = "same_uid"
        expect(user).to be_valid
      end
    end

    context "OAuthユーザー（LINE）" do
      let(:user) { build(:user, :line_oauth) }

      it "providerとuidがあれば有効" do
        expect(user).to be_valid
      end

      it "uidがなければ無効" do
        user.uid = nil
        expect(user).not_to be_valid
        expect(user.errors[:uid]).to be_present
      end

      it "同じprovider内でuidが重複していれば無効" do
        create(:user, provider: "line", uid: "duplicate_line_uid")
        user.uid = "duplicate_line_uid"
        expect(user).not_to be_valid
        expect(user.errors[:uid]).to be_present
      end
    end
  end

  # クラスメソッドのテスト
  describe ".from_omniauth" do
    let(:auth) do
      OmniAuth::AuthHash.new(
        provider: "google_oauth2",
        uid: "12345",
        info: {
          email: "oauth_user@example.com"
        }
      )
    end

    context "新規ユーザーの場合" do
      it "ユーザーが作成される" do
        expect {
          User.from_omniauth(auth)
        }.to change(User, :count).by(1)
      end

      it "正しい情報でユーザーが作成される" do
        user = User.from_omniauth(auth)
        expect(user.provider).to eq("google_oauth2")
        expect(user.uid).to eq("12345")
        expect(user.email).to eq("oauth_user@example.com")
        expect(user.password).to be_present
      end
    end

    context "既存ユーザーの場合" do
      before do
        User.from_omniauth(auth)
      end

      it "ユーザーが作成されない" do
        expect {
          User.from_omniauth(auth)
        }.not_to change(User, :count)
      end

      it "既存のユーザーが返される" do
        user = User.from_omniauth(auth)
        expect(user.email).to eq("oauth_user@example.com")
      end
    end

    context "LINEでメールアドレスがない場合" do
      let(:line_auth) do
        OmniAuth::AuthHash.new(
          provider: "line",
          uid: "67890",
          info: {
            email: nil
          }
        )
      end

      it "ダミーメールアドレスが生成される" do
        user = User.from_omniauth(line_auth)
        expect(user.email).to eq("line-67890@example.com")
      end
    end
  end

  # インスタンスメソッドのテスト
  describe "#own?" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:post) { create(:post, user: user) }

    it "自分の投稿であればtrueを返す" do
      expect(user.own?(post)).to be true
    end

    it "他人の投稿であればfalseを返す" do
      expect(other_user.own?(post)).to be false
    end

    it "オブジェクトがnilの場合はfalseを返す" do
      expect(user.own?(nil)).to be false
    end
  end

  describe "bookmark methods" do
    let(:user) { create(:user) }
    let(:post) { create(:post) }

describe "#bookmark" do
      it "投稿をブックマークできる" do
        expect {
          user.bookmark(post)
        }.to change(user.bookmark_posts, :count).by(1)
      end

      it "ブックマークした投稿がbookmark_postsに含まれる" do
        user.bookmark(post)
        expect(user.bookmark_posts).to include(post)
      end
    end

    describe "#unbookmark" do
      before do
        user.bookmark(post)
      end

      it "投稿のブックマークを解除できる" do
        expect {
          user.unbookmark(post)
        }.to change(user.bookmark_posts, :count).by(-1)
      end

      it "ブックマーク解除後、bookmark_postsに含まれない" do
        user.unbookmark(post)
        expect(user.bookmark_posts).not_to include(post)
      end
    end

    describe "#bookmark?" do
      context "ブックマーク済みの投稿" do
        before do
          user.bookmark(post)
        end

        it "trueを返す" do
          expect(user.bookmark?(post)).to be true
        end
      end

      context "ブックマークしていない投稿" do
        it "falseを返す" do
          expect(user.bookmark?(post)).to be false
        end
      end
    end
  end

  describe ".create_unique_string" do
    it "UUIDを生成する" do
      uuid = User.create_unique_string
      expect(uuid).to be_present
      expect(uuid).to match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/)
    end

    it "毎回異なる値を返す" do
      uuid1 = User.create_unique_string
      uuid2 = User.create_unique_string
      expect(uuid1).not_to eq(uuid2)
    end
  end
end
