class Prediction
  attr_reader :gender, :birth_date, :measurement_date, :measurement_type, :value

  def initialize(gender:, birth_date:, measurement_date:, measurement_type:, value:)
    @gender = gender
    @birth_date = birth_date.to_date
    @measurement_date = measurement_date.to_date
    @measurement_type = measurement_type
    @value = value.to_f
  end

  def calculate
    percentile = find_percentile
    predict_growth(percentile)
  end

  private

  def find_percentile
    days_since_birth_at_measurement = (measurement_date - birth_date).to_i

    GrowthStandard.where(gender: gender, measurement_type: measurement_type)
                  #.where("days_since_birth <= ?", days_since_birth_at_measurement)
                  .where(days_since_birth: days_since_birth_at_measurement)
                  .order(Arel.sql("abs(value - #{value})"))
                  .limit(1)
                  .pluck(:percentile)
                  .first
  end

  def predict_growth(percentile)

  # 季節の開始日を定義
  season_start_dates = {
    winter: Date.new(Date.today.year, 12, 1),
    spring: Date.new(Date.today.year, 4, 1),
    summer: Date.new(Date.today.year, 6, 1),
    autumn: Date.new(Date.today.year, 10, 1)
  }

  today = Date.today
  days_since_birth_today = (today - birth_date).to_i

  future_predictions = []

  # 先の4季節分を予測
  season_start_dates.keys.each do |future_season|
    season_date = season_start_dates[future_season]

    # もし季節の日付が今日より過去の場合は、本日の年＋1に変更
    season_date = season_date.change(year: today.year + 1) if season_date < today

    future_days_since_birth = days_since_birth_today + (season_date - today).to_i
    future_season_date_since_today = (season_date - today).to_i

    predicted_value = GrowthStandard.where(gender: gender, measurement_type: measurement_type)
                                    .where(days_since_birth: future_days_since_birth)
                                    .where(percentile: percentile)
                                    .pluck(:value)
                                    .first

    future_predictions << { season: future_season, height: predicted_value, days: future_season_date_since_today }
  end

  future_predictions
  end

end