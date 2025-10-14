class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.build(create_comment_params.merge(post_id: @post.id))
    @comment.save
  end

  def show
    # キャンセル時に元の表示に戻す
  end

  def edit
    # 編集フォーム用のアクション（Turbo Stream使用のため空）
  end

  def update
    @comment.update(update_comment_params)
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
  end

  private

  def set_comment
    @comment = current_user.comments.find(params[:id])
  end

  # 作成時用
  def create_comment_params
    params.require(:comment).permit(:body).merge(post_id: params[:post_id])
  end

  # 更新時用
  def update_comment_params
    params.require(:comment).permit(:body)
  end
end
