class Members::ChildrenController < ApplicationController
  before_action :authenticate_user!
  before_action :set_child, only: [:edit, :update, :destroy]

  def new
    @child = current_user.children.build
    # 身長・体重の入力欄をフォームに表示させるために新しい測定インスタンスを2つ用意
    @child.measurements.build(measurement_type: "height")
    @child.measurements.build(measurement_type: "weight")
  end


  def create
    @child = current_user.children.build(child_params)
    if @child.save
      redirect_to members_mypage_path, notice: "お子さま情報を登録しました。"
    else
      flash.now[:alert] = "登録に失敗しました。"
      render :new
    end
  end


  def edit
    # 最新の測定値がある場合はフォームに表示するために代入、なければ新しくbuild
    %w[height weight].each do |type|
      unless @child.measurements.find { |m| m.measurement_type == type }
        @child.measurements.build(measurement_type: type)
      end
    end
  end

  def update
    if @child.update(child_params)
      redirect_to members_mypage_path, notice: "お子さま情報を更新しました。"
    else
      flash.now[:alert] = "更新に失敗しました。"
      render :edit
    end
  end

  def destroy
    @child.destroy
    redirect_to members_mypage_path, notice: "お子さま情報を削除しました。"
  end

  private

  def set_child
    @child = current_user.children.includes(:measurements).find(params[:id])
  end

  def child_params
    params.require(:child).permit(
      :name, :gender, :birthday,
      measurements_attributes: [:id, :value, :measured_on, :measurement_type, :_destroy]
    )
  end
end
