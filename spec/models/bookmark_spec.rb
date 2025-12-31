require "rails_helper"

RSpec.describe Bookmark, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end

  describe "validations" do
    let(:user) { create(:user) }
    let(:post) { create(:post) }

    it "同じユーザーが同じ投稿を複数回ブックマークできない" do
      create(:bookmark, user: user, post: post)

      duplicate = build(:bookmark, user: user, post: post)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:user_id]).to be_present
    end

    it "異なるユーザーなら同じ投稿をブックマークできる" do
      create(:bookmark, user: user, post: post)

      another_user = create(:user)
      another_bookmark = build(:bookmark, user: another_user, post: post)

      expect(another_bookmark).to be_valid
    end

    it "同じユーザーでも異なる投稿ならブックマークできる" do
      create(:bookmark, user: user, post: post)

      another_post = create(:post)
      another_bookmark = build(:bookmark, user: user, post: another_post)

      expect(another_bookmark).to be_valid
    end
  end
end
