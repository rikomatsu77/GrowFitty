class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("RESEND_FROM_EMAIL", "no-reply@growfitty.com")
  layout "mailer"
end
