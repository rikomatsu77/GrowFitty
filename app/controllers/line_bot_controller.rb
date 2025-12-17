class LineBotController < ApplicationController
  protect_from_forgery except: [:callback]

  require "line/bot"

  def callback

  body = request.body.read
  signature = request.env["HTTP_X_LINE_SIGNATURE"]

  unless client.validate_signature(body, signature)
    render plain: "Bad Request", status: :bad_request
    return
  end

  events = client.parse_events_from(body)

  events.each do |event|
    next unless event.is_a?(Line::Bot::Event::Message)
    next unless event.message["type"] == "text"

    handle_text_message(event)
  end

  render plain: "OK"
  end


  private

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token  = ENV["LINE_CHANNEL_TOKEN"]
    end
  end
  
  def handle_text_message(event)
    # LINEユーザーIDを取得
    line_user_id = event["source"]["userId"]
    
    # メッセージのテキストを取得（前後の空白を削除）
    text = event.message["text"].strip
    
    # ユーザーの会話状態を取得または新規作成
    conversation = LineConversation.find_or_create_by(line_user_id: line_user_id)
    
    # 「サイズ予測」で会話をリセット
    if text == "サイズ予測"
        conversation.reset!
        reply_message(event, ask_gender_message)
        return
    end
    
    # 現在のステータスに応じて処理を分岐
    case conversation.status
    when "ask_gender"
      handle_gender(event, conversation, text)
    when "ask_birth_date"
      handle_birth_date(event, conversation, text)
    when "ask_measurement_date"
      handle_measurement_date(event, conversation, text)
    when "ask_measurement_type"
      handle_measurement_type(event, conversation, text)
    when "ask_value"
      handle_value(event, conversation, text)
    else
      reply_message(event, default_message)
    end
  end

  # 各ステップの処理
  def handle_gender(event, conversation, text)
    if text == "男の子"
      conversation.update!(gender: "male", status: "ask_birth_date")
      reply_message(event, ask_birth_date_message)
    elsif text == "女の子"
      conversation.update!(gender: "female", status: "ask_birth_date")
      reply_message(event, ask_birth_date_message)
    else
      reply_message(event, "「男の子」または「女の子」を選択してください。")
    end
  end

  def handle_birth_date(event, conversation, text)
    begin
      birth_date = Date.parse(text)

      if birth_date > Date.today
        reply_message(event, "未来の日付は入力できません。\n正しい生年月日を入力してください。")
        return
      end

      conversation.update!(birth_date: birth_date, status: "ask_measurement_date")
      reply_message(event, ask_measurement_date_message)

    rescue ArgumentError
      reply_message(event, "正しい日付形式で入力してください。\n例: 2020-01-15")
    end
  end

  def handle_measurement_date(event, conversation, text)
    begin
      measurement_date = Date.parse(text)
      
      if measurement_date < conversation.birth_date
        reply_message(event, "測定日は生年月日より後の日付を入力してください。")
        return
      end
      
      conversation.update!(measurement_date: measurement_date, status: "ask_measurement_type")
      reply_message(event, ask_measurement_type_message)
    rescue ArgumentError
      reply_message(event, "正しい日付形式で入力してください。\n例: 2024-01-15")
    end
  end

  def handle_measurement_type(event, conversation, text)
    if text == "身長"
      conversation.update!(measurement_type: "height", status: "ask_value")
      reply_message(event, ask_value_message("身長", "cm"))
    elsif text == "体重"
      conversation.update!(measurement_type: "weight", status: "ask_value")
      reply_message(event, ask_value_message("体重", "kg"))
    else
      reply_message(event, "「身長」または「体重」を選択してください。")
    end
  end

  def handle_value(event, conversation, text)
    value = text.to_f
    
    if value <= 0
      reply_message(event, "正しい数値を入力してください。")
      return
    end
    
    conversation.update!(value: value)
    
    # 予測計算を実行
    result_message = calculate_prediction(conversation)
    
    # 会話をリセット
    conversation.destroy
    
    reply_message(event, result_message)
  end

  # 予測計算を実行するメソッド
  def calculate_prediction(conversation)
    prediction = Prediction.new(
      gender: conversation.gender,
      birth_date: conversation.birth_date,
      measurement_date: conversation.measurement_date,
      measurement_type: conversation.measurement_type,
      value: conversation.value
    )
    
    seasonal_data, current_value = prediction.calculate
    
    # 結果メッセージを作成して返す
    build_result_message(conversation, seasonal_data, current_value)
  end

  def build_result_message(conversation, seasonal_data, current_value)
    type_name = conversation.measurement_type == "height" ? "身長" : "体重"
    unit = conversation.measurement_type == "height" ? "cm" : "kg"
    
    message = "📊 サイズ予測結果\n\n"
    message += "【測定結果】\n"
    message += "現在の#{type_name}: #{sprintf("%.1f", current_value)}#{unit}\n\n"
    message += "【今日の季節から1年先までの予測】\n"
    
    # 今日からの日数順にソート(近い順)
    sorted_seasonal_data = seasonal_data.sort_by { |data| data[:days] }
    
    sorted_seasonal_data.each do |season_data|
      season_name = translate_season(season_data[:season])
      predicted_value = sprintf("%.1f", season_data[:height])
      days = season_data[:days]
      
      message += "#{season_name}: #{predicted_value}#{unit}(あと#{days}日)\n"
    end
    
    message += "\n※この予測は統計データに基づく参考値です。"
    message
  end

  # 季節名を日本語に変換
  def translate_season(season_symbol)
    season_names = {
      spring: "春",
      summer: "夏",
      autumn: "秋",
      winter: "冬"
    }
    season_names[season_symbol] || season_symbol.to_s
  end

  # メッセージ定義
  def ask_gender_message
    "お子さんの性別を教えてください。\n「男の子」または「女の子」を入力してください。"
  end

  def ask_birth_date_message
    "お子さんの生年月日を教えてください。\n例: 2020-01-15"
  end

  def ask_measurement_date_message
    "測定日を教えてください。\n例: 2024-01-15"
  end

  def ask_measurement_type_message
    "測定タイプを選択してください。\n「身長」または「体重」を入力してください。"
  end

  def ask_value_message(type_name, unit)
    "現在の#{type_name}を教えてください。\n例: 105.5 (単位: #{unit})"
  end

  def default_message
    "「サイズ予測」と入力して予測を開始してください。"

  end

  # メッセージ返信
  def reply_message(event, text)
    message = {
      type: "text",
      text: text
    }
    client.reply_message(event["replyToken"], message)
  end
end
