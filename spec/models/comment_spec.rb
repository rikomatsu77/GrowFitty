require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end

  describe "validations" do
    let(:comment) { build(:comment) }

    it "bodyがあれば有効" do
      expect(comment).to be_valid
    end

    it "bodyがなければ無効" do
      comment.body = nil
      expect(comment).not_to be_valid
      expect(comment.errors[:body]).to be_present
    end

    it "bodyが65535文字以内であれば有効" do
      comment.body = "a" * 65_535
      expect(comment).to be_valid
    end

    it "bodyが65536文字以上だと無効" do
      comment.body = "a" * 65_536
      expect(comment).not_to be_valid
      expect(comment.errors[:body]).to be_present
    end
  end
end
