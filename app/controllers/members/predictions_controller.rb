class Members::PredictionsController < ApplicationController
  before_action :authenticate_user!

  def create
    children_results = []

    current_user.children.each do |child|

      name = child.name
      birth_date = child.birthday
      gender = child.gender

      latest_height = child.latest_height
      latest_weight = child.latest_weight
      latest_height_date = child.latest_measured_on_h
      latest_weight_date = child.latest_measured_on_w

      height_prediction = nil
      weight_prediction = nil
      height_current = nil
      weight_current = nil

      if latest_height.present? && latest_height_date.present?
        prediction = Prediction.new(
          gender: gender,
          birth_date: birth_date,
          measurement_date: latest_height_date,
          measurement_type: 'height',
          value: latest_height
        )
        height_prediction, height_current = prediction.calculate
      end

      if latest_weight.present? && latest_weight_date.present?
        prediction = Prediction.new(
          gender: gender,
          birth_date: birth_date,
          measurement_date: latest_weight_date,
          measurement_type: 'weight',
          value: latest_weight
        )
        weight_prediction, weight_current = prediction.calculate
      end

      children_results << {
        name: name,
        height_prediction: height_prediction,
        weight_prediction: weight_prediction,
        height_current: height_current,
        weight_current: weight_current
      }
    end


    if children_results.empty?
      flash[:alert] = "予測できるデータがありません。入力してください。"
      redirect_to members_mypage_path and return
    end

    # **session に保存**
    session[:children_results] = children_results


    redirect_to members_prediction_result_path
  end

  def result
    # **session からデータを取得**
    @children_results = session[:children_results] || []


    # **データを使い終わったら session から削除**
    session.delete(:children_results)
  end
end
