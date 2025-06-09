class Members::MypagesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @children = @user.children.includes(:measurements)
  end

  def edit
    @user = current_user
    @children = @user.children.includes(:measurements).presence || [] # 子どもがいない場合は空の配列を代入
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to members_mypage_path, notice: "プロフィールを更新しました。"
    else
      flash.now[:alert] = "更新に失敗しました。"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :email)
  end
end
