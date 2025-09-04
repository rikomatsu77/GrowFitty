# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  protected
  # Google認証ユーザー用のUID生成
  def build_resource(hash = {})
    hash[:uid] = User.create_unique_string
    super
  end

  # パスワードなしでプロフィール更新を許可
  def update_resource(resource, params)
    return super if params["password"].present?
    resource.update_without_password(params.except("current_password"))
  end

  # 更新後にマイページへリダイレクト
  def after_update_path_for(resource)
    members_mypage_path
  end
end
