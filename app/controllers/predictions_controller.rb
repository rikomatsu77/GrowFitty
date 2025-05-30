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
    puts "DEBUG: seasonal_data: #{seasonal_data}"
    puts "DEBUG: current_height: #{params[:value]}"
    redirect_to prediction_result_path(seasonal_data: seasonal_data, current_height: params[:value])
  end
end
