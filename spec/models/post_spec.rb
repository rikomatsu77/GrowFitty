require "rails_helper"

RSpec.describe Post, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:bookmarks).dependent(:destroy) }
    it { should have_many(:post_tags).dependent(:destroy) }
    it { should have_many(:tags).through(:post_tags) }
  end

  describe "validations" do
    let(:post) { build(:post) }

    it "titleとbodyがあれば有効" do
      expect(post).to be_valid
    end

    it "titleがなければ無効" do
      post.title = nil
      expect(post).not_to be_valid
      expect(post.errors[:title]).to be_present
    end

    it "bodyがなければ無効" do
      post.body = nil
      expect(post).not_to be_valid
      expect(post.errors[:body]).to be_present
    end
  end

  describe "#save_post_tags" do
    let(:post) { create(:post) }

    it "タグを新規追加できる" do
      expect {
        post.save_post_tags(["Ruby", "Rails"])
      }.to change(Tag, :count).by(2)

      expect(post.tags.pluck(:name)).to match_array(["Ruby", "Rails"])
    end

    it "既存タグを削除できる" do
      post.save_post_tags(["Ruby", "Rails"])
      post.save_post_tags(["Ruby"])

      expect(post.tags.pluck(:name)).to eq(["Ruby"])
    end
  end

  describe ".ransackable_attributes" do
    it "検索可能な属性を返す" do
      expect(Post.ransackable_attributes).to contain_exactly("title", "body")
    end
  end

  describe ".ransackable_associations" do
    it "検索可能な関連を返す" do
      expect(Post.ransackable_associations).to contain_exactly(
        "bookmarks",
        "post_tags",
        "tags",
        "user"
      )
    end
  end
end
