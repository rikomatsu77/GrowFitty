require 'resend'

class DeviseMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers
  default template_path: "devise/mailer"

  # パスワードリセットメールを送信
  def reset_password_instructions(record, token, opts = {})
    @resource = record
    @token = token

    # Resend API を使ってメールを送信
    send_via_resend(
      to: record.email,
      subject: "パスワード再設定のご案内",
      html: reset_password_instructions_html(record, token)
    )
  end

  private

  def send_via_resend(to:, subject:, html:)
    # 本番環境でのみ Resend API を呼び出す
    if Rails.env.production?
      Resend.api_key = ENV['RESEND_API_KEY']

      Resend::Emails.send({
        from: 'noreply@growfitty.com',
        to: to,
        subject: subject,
        html: html
      })
    else
      # 開発環境ではログに出力
      Rails.logger.info "=" * 50
      Rails.logger.info "メール送信: #{to}"
      Rails.logger.info "件名: #{subject}"
      Rails.logger.info "内容:\n#{html}"
      Rails.logger.info "=" * 50
    end
  end

  def reset_password_instructions_html(record, token)
    <<~HTML
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="UTF-8">
        </head>
        <body>
          <p>#{record.user_name} 様</p>
          <p>パスワード再設定のご依頼を受け付けました。</p>
          <p>下記のリンクをクリックし、新しいパスワードを設定してください。</p>
          <p><a href="#{edit_user_password_url(record, reset_password_token: token)}">パスワードを再設定する</a></p>
          <p>※ このメールに心当たりがない場合は、何も操作せず破棄してください。</p>
          <p>上記リンクにアクセスして新しいパスワードを設定するまで、パスワードは変更されません。</p>
        </body>
      </html>
    HTML
  end
end
