class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("RESEND_FROM_EMAIL")
  layout "mailer"
end
