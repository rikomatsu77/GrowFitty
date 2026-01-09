require "rails_helper"

RSpec.describe "UserSessions", type: :system do
  let(:user) { create(:user, password: "password123") }

  describe "ログイン前" do
    context "フォームの入力値が正常" do
      it "ログイン処理が成功する" do
        visit new_user_session_path

        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: "password123"
        click_button "ログイン"

        expect(page).to have_content "ログインしました。"
        expect(current_path).to eq root_path
      end
    end

    context "フォームの入力値が不正" do
      it "ログイン処理が失敗する" do
        visit new_user_session_path

        fill_in "メールアドレス", with: ""
        fill_in "パスワード", with: "password123"
        click_button "ログイン"

        expect(page).to have_content "メールアドレスまたはパスワードが間違っています。"
        expect(current_path).to eq new_user_session_path
      end
    end
  end

  describe "ログイン後" do
    context "ログアウトボタンをクリック" do
      it "ログアウト処理が成功する" do
        visit new_user_session_path

        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: "password123"
        click_button "ログイン"

        find("[data-testid=\"hamburger-menu\"]").click

        expect(page).to have_selector("[data-testid=\"logout-link\"]")

        find("[data-testid=\"logout-link\"]").click

        expect(page).to have_content "ログアウトしました。"
        expect(current_path).to eq root_path
      end
    end
  end
end
