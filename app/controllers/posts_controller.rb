class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  # 投稿者本人かをチェック：編集・更新・削除のみ対象
  before_action :authorize_post_owner, only: [:edit, :update, :destroy]

  def index
    @posts = Post.includes(:user)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user

    if @post.save
      redirect_to posts_path, notice: "投稿が作成されました。"
    else
      render :new
    end
  end

  def show
    @post = Post.includes(:user).find(params[:id])
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "投稿が更新されました。"
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "投稿を削除しました。"
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :post_image, :post_image_cache)
  end

  def authorize_post_owner
    @post = Post.find(params[:id])
    unless @post.user == current_user
      redirect_to posts_path, alert: "この投稿を操作する権限がありません。"
    end
  end
end
