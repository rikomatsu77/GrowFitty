require "rails_helper"

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }

  describe "ログイン前" do
    it "新規登録ができる" do
      visit root_path

      click_link "新規登録"

      fill_in "user[email]", with: "test@example.com"
      fill_in "user[password]", with: "password"
      fill_in "user[password_confirmation]", with: "password"

      find("input[type='submit']").click


      expect(page).to have_content("アカウント登録が完了しました")
    end

    it "未ログインではマイページにアクセスできない" do
      visit members_mypage_path

      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content("ログインするか、新規登録してください。")
    end
  end

  describe "ログイン後" do
    before do
      login(user)
    end

    it "マイページに遷移できる" do

      visit members_mypage_path

      expect(page).to have_content("ユーザー名")
      expect(page).to have_content(user.user_name)
    end


    it "ユーザー情報を編集できる" do
      visit edit_members_mypage_path

      fill_in "ユーザー名", with: "新しいユーザー名"
      fill_in "メールアドレス", with: "updated@example.com"

      click_button type: "submit"

      expect(page).to have_current_path(members_mypage_path)
      expect(page).to have_content("アカウント情報を更新しました。")
      expect(page).to have_content("新しいユーザー名")
    end
  end
end
