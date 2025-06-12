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
  if @user.update(user_params)
    flash[:notice] = "プロフィール情報を更新しました。"
    redirect_to members_mypage_path
  else
    flash.now[:alert] = "更新に失敗しました。入力を確認してください。"
    render :edit
  end
end

  private

  def user_params
    params.require(:user).permit(:user_name, :email)
  end
end
