require "rails_helper"

RSpec.describe "Posts", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "ログイン前" do
    it "未ログインでは投稿作成ページにアクセスできない" do
      visit new_post_path

      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content("ログイン")
    end

    it "未ログイン時は編集・削除アイコンが表示されない" do
      post = create(:post, user: user)

      visit post_path(post)

      expect(page).not_to have_selector("[data-testid='edit-post']")
      expect(page).not_to have_selector("[data-testid='delete-post']")
    end
  end


  describe "ログイン後" do
    before do
      login(user)
    end

    it "投稿を作成できる" do
      visit new_post_path

      fill_in "タイトル", with: "テスト投稿"
      fill_in "本文", with: "投稿本文です"
      click_button "投稿する"

      expect(page).to have_content("投稿が作成されました")
      expect(page).to have_content("テスト投稿")
      expect(page).to have_content("投稿本文です")
    end

    it "自分の投稿は編集できる" do
      post = create(:post, user: user)

      visit post_path(post)

      find("[data-testid='edit-post']").click

      expect(page).to have_current_path(edit_post_path(post))
    end

    it "他人の投稿では編集・削除アイコンが表示されない" do
      post = create(:post, user: other_user)

      visit post_path(post)

      expect(page).not_to have_selector("[data-testid='edit-post']")
      expect(page).not_to have_selector("[data-testid='delete-post']")
    end

    it "自分の投稿を削除できる" do
      post = create(:post, user: user)

      visit post_path(post)

      accept_confirm do
        find("[data-testid='delete-post']").click
      end

      expect(page).to have_content("投稿を削除しました")
      expect(page).not_to have_content(post.title)
    end
  end
end
