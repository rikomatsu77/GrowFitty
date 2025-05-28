class PredictionsController < ApplicationController
  def new
  end

  def create
    prediction = Prediction.new(
      gender: params[:gender],
      birth_date: params[:birth_date],
      measurement_date: params[:measurement_date],
      measurement_type: params[:measurement_type],
      value: params[:value]
    )

    seasonal_data = prediction.calculate

    redirect_to prediction_result_path, flash: { seasonal_data: seasonal_data, current_season: current_season, current_height: params[:value] }
  end
end
