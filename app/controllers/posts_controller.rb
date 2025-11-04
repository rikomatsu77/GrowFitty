class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  # 投稿者本人かをチェック：編集・更新・削除のみ対象
  before_action :authorize_post_owner, only: [:edit, :update, :destroy]

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:user, :tags).order(created_at: :desc).page(params[:page])

    # タグでの絞り込み
    if params[:tag].present?
      @posts = @posts.joins(:tags).where(tags: { name: params[:tag] })
    end
    @selected_tag = params[:tag]
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    tag_list = (params[:post][:tag_names] || "").split(",")

    if @post.save
      @post.save_post_tags(tag_list)
      redirect_to posts_path, notice: "投稿が作成されました。"
    else
      render :new
    end
  end

  def show
    @post = Post.includes(:user).find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :desc)
  end

  def edit
    @tag_list = @post.tags.pluck(:name).join(",")
  end

  def update
    tag_list = (params[:post][:tag_names] || "").split(",").map(&:strip).reject(&:blank?)
    if @post.update(post_params)
      @post.save_post_tags(tag_list)
      redirect_to post_path(@post), notice: "投稿が更新されました。"
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "投稿を削除しました。"
  end

  def bookmarks
    @q = current_user.bookmark_posts.ransack(params[:q])
    @bookmark_posts = @q.result(distinct: true).includes(:user, :tags).order(created_at: :desc)

    # タグでの絞り込み
    if params[:tag].present?
      @bookmark_posts = @bookmark_posts.joins(:tags).where(tags: { name: params[:tag] })
    end
    @selected_tag = params[:tag]
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :post_image, :post_image_cache, :tag_names)
  end

  def authorize_post_owner
    @post = Post.find(params[:id])
    unless @post.user == current_user
      redirect_to posts_path, alert: "この投稿を操作する権限がありません。"
    end
  end
end
